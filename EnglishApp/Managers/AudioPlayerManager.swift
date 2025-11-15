//
//  AudioPlayerManager.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import AVFoundation
import Combine

@MainActor
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
            playbackError = "Audio session setup failed: \(error.localizedDescription)"
        }
    }

    func loadAudio(_ audioMaterial: AudioMaterial) {
        // Ensure all published property changes happen on main thread
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            self.reset()
            self.isLoading = true
            self.currentAudio = audioMaterial

            // For now, use mock URL since we don't have actual audio files
            // In a real app, this would load from Bundle.main or a network URL
            let mockURL: URL?

            if let filename = audioMaterial.filename {
                // Try to load from bundle (will fail gracefully if file doesn't exist)
                mockURL = Bundle.main.url(forResource: filename.replacingOccurrences(of: ".mp3", with: ""), withExtension: "mp3")
            } else if let urlString = audioMaterial.url {
                mockURL = URL(string: urlString)
            } else {
                mockURL = nil
            }

            // Since we don't have actual audio files, simulate loading
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                guard let self = self else { return }

                if let url = mockURL {
                    self.setupPlayer(with: url, duration: audioMaterial.duration)
                } else {
                    // Mock playback for development
                    self.setupMockPlayer(duration: audioMaterial.duration)
                }

                self.isLoading = false
            }
        }
    }

    private func setupPlayer(with url: URL, duration: TimeInterval) {
        let playerItem = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: playerItem)
        self.duration = duration

        addTimeObserver()
        addPlayerObservers()
    }

    private func setupMockPlayer(duration: TimeInterval) {
        // For development without actual audio files
        self.duration = duration
        self.currentTime = 0
        // Mock player is ready to "play"
    }

    private func addTimeObserver() {
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
        if player != nil {
            player?.play()
            isPlaying = true
        } else {
            // Mock play for development
            isPlaying = true
            startMockPlayback()
        }
    }

    func pause() {
        if player != nil {
            player?.pause()
        }
        isPlaying = false
        stopMockPlayback()
    }

    func seekBackward(by seconds: TimeInterval = 10) {
        let newTime = max(0, currentTime - seconds)
        seek(to: newTime)
    }

    func seekForward(by seconds: TimeInterval = 10) {
        let newTime = min(duration, currentTime + seconds)
        seek(to: newTime)
    }

    private func seek(to time: TimeInterval) {
        if let player = player {
            let cmTime = CMTime(seconds: time, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
            player.seek(to: cmTime)
        }
        currentTime = time
    }

    func reset() {
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
        stopMockPlayback()
        player = nil
        isPlaying = false
        currentTime = 0
        duration = 0
        playbackError = nil
    }

    private func handlePlaybackEnded() {
        isPlaying = false
        currentTime = 0
        player?.seek(to: .zero)
    }

    // MARK: - Mock Playback (for development without audio files)
    private var mockPlaybackTimer: Timer?

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

    private func stopMockPlayback() {
        mockPlaybackTimer?.invalidate()
        mockPlaybackTimer = nil
    }

    private func handleMockPlaybackEnded() {
        stopMockPlayback()
        isPlaying = false
        currentTime = 0
    }

    deinit {
        reset()
    }
}
