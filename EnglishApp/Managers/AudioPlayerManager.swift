//
//  AudioPlayerManager.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import AVFoundation
import Combine

class AudioPlayerManager: ObservableObject {
    static let shared = AudioPlayerManager()

    @Published var isPlaying: Bool = false
    @Published var currentTime: TimeInterval = 0
    @Published var duration: TimeInterval = 0
    @Published var isLoading: Bool = false
    @Published var currentAudio: AudioMaterial?
    @Published var playbackError: String?

    private var player: AVPlayer?
    private var timeObserver: Any?
    private var cancellables = Set<AnyCancellable>()

    private init() {
        setupAudioSession()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            Task { @MainActor in
                self.playbackError = "Audio session setup failed: \(error.localizedDescription)"
            }
        }
    }

    func loadAudio(_ audioMaterial: AudioMaterial) async {
        // Update UI state on main thread
        await MainActor.run {
            self.reset()
            self.isLoading = true
            self.currentAudio = audioMaterial
        }

        // Heavy work on background thread - file/URL resolution
        let mockURL: URL?

        if let filename = audioMaterial.filename {
            // Try to load from bundle (will fail gracefully if file doesn't exist)
            mockURL = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".mp3", with: ""), withExtension: "mp3")
        } else if let urlString = audioMaterial.url {
            mockURL = URL(string: urlString)
        } else {
            mockURL = nil
        }

        // Simulate loading delay (background work)
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds

        // Setup player on background thread
        if let url = mockURL {
            await setupPlayer(with: url, duration: audioMaterial.duration)
        } else {
            // Mock playback for development
            await setupMockPlayer(duration: audioMaterial.duration)
        }

        // Update UI state on main thread
        await MainActor.run {
            self.isLoading = false
        }
    }

    private func setupPlayer(with url: URL, duration: TimeInterval) async {
        // Create player on background thread
        let playerItem = AVPlayerItem(url: url)
        let newPlayer = AVPlayer(playerItem: playerItem)

        // Update UI state on main thread
        await MainActor.run {
            self.player = newPlayer
            self.duration = duration
            self.addTimeObserver()
            self.addPlayerObservers()
        }
    }

    private func setupMockPlayer(duration: TimeInterval) async {
        // For development without actual audio files
        await MainActor.run {
            self.duration = duration
            self.currentTime = 0
            // Mock player is ready to "play"
        }
    }

    private func addTimeObserver() {
        // Remove existing observer if any to prevent multiple observers
        if let existingObserver = timeObserver {
            player?.removeTimeObserver(existingObserver)
            timeObserver = nil
        }

        let interval = CMTime(seconds: 0.1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        timeObserver = player?.addPeriodicTimeObserver(forInterval: interval, queue: .main) { [weak self] time in
            guard let self = self else { return }
            self.currentTime = time.seconds
        }
    }

    private func addPlayerObservers() {
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.handlePlaybackEnded()
            }
            .store(in: &cancellables)
    }

    func play() {
        Task { @MainActor in
            if self.player != nil {
                self.player?.play()
                self.isPlaying = true
            } else {
                // Mock play for development
                self.isPlaying = true
                self.startMockPlayback()
            }
        }
    }

    func pause() {
        Task { @MainActor in
            if self.player != nil {
                self.player?.pause()
            }
            self.isPlaying = false
            self.stopMockPlayback()
        }
    }

    func seekBackward(by seconds: TimeInterval = 10) {
        Task { @MainActor in
            let newTime = max(0, self.currentTime - seconds)
            self.seek(to: newTime)
        }
    }

    func seekForward(by seconds: TimeInterval = 10) {
        Task { @MainActor in
            let newTime = min(self.duration, self.currentTime + seconds)
            self.seek(to: newTime)
        }
    }

    private func seek(to time: TimeInterval) {
        Task { @MainActor in
            if let player = self.player {
                let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
                player.seek(to: cmTime)
            }
            self.currentTime = time
        }
    }

    func reset() {
        Task { @MainActor in
            self.cleanupPlayerResources()
            self.isPlaying = false
            self.currentTime = 0
            self.duration = 0
            self.playbackError = nil
        }
    }

    @MainActor
    private func cleanupPlayerResources() {
        // Remove time observer to prevent memory leak
        if let timeObserver = self.timeObserver {
            self.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        // Stop mock playback timer
        self.stopMockPlayback()

        // Release player
        self.player = nil
    }

    private func handlePlaybackEnded() {
        Task { @MainActor in
            self.isPlaying = false
            self.currentTime = 0
            self.player?.seek(to: .zero)
        }
    }

    // MARK: - Mock Playback (for development without audio files)
    private var mockPlaybackTimer: Timer?

    @MainActor
    private func startMockPlayback() {
        mockPlaybackTimer?.invalidate()
        mockPlaybackTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            if self.currentTime < self.duration {
                self.currentTime += 0.1
            } else {
                self.handleMockPlaybackEnded()
            }
        }
    }

    @MainActor
    private func stopMockPlayback() {
        mockPlaybackTimer?.invalidate()
        mockPlaybackTimer = nil
    }

    @MainActor
    private func handleMockPlaybackEnded() {
        stopMockPlayback()
        isPlaying = false
        currentTime = 0
    }

    deinit {
        // Synchronous cleanup in deinit to prevent memory leaks
        // Remove time observer immediately
        if let timeObserver = self.timeObserver {
            self.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }

        // Stop timers
        mockPlaybackTimer?.invalidate()
        mockPlaybackTimer = nil

        // Release player
        self.player = nil

        // Cancel all subscriptions
        cancellables.removeAll()
    }
}
