//
//  ListeningPracticeViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import Combine

@MainActor
class ListeningPracticeViewModel: ObservableObject {
    @Published var audioMaterials: [AudioMaterial] = []
    @Published var currentAudio: AudioMaterial?
    @Published var upcomingAudio: [AudioMaterial] = []

    private let audioPlayer = AudioPlayerManager.shared
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadAudioMaterials()
        observeAudioPlayer()
    }

    private func loadAudioMaterials() {
        audioMaterials = AudioMaterial.mockAudioMaterials

        // Auto-select first unlocked audio
        if let firstAudio = audioMaterials.first(where: { !$0.isLocked }) {
            selectAudio(firstAudio)
        }
    }

    private func observeAudioPlayer() {
        audioPlayer.$currentAudio
            .assign(to: &$currentAudio)
    }

    func selectAudio(_ audio: AudioMaterial) {
        guard !audio.isLocked else { return }

        currentAudio = audio
        audioPlayer.loadAudio(audio)
        updateUpcomingAudio()
    }

    private func updateUpcomingAudio() {
        guard let current = currentAudio else {
            upcomingAudio = audioMaterials
            return
        }

        // Get all audio after the current one
        if let currentIndex = audioMaterials.firstIndex(where: { $0.id == current.id }) {
            let afterCurrent = audioMaterials.suffix(from: min(currentIndex + 1, audioMaterials.count))
            upcomingAudio = Array(afterCurrent)
        } else {
            upcomingAudio = audioMaterials.filter { $0.id != current.id }
        }
    }

    func togglePlayPause() {
        if audioPlayer.isPlaying {
            audioPlayer.pause()
        } else {
            audioPlayer.play()
        }
    }

    func seekBackward() {
        audioPlayer.seekBackward(by: 10)
    }

    func seekForward() {
        audioPlayer.seekForward(by: 10)
    }

    func getCompletedCount() -> Int {
        // Mock implementation - in a real app, this would track completed audio
        return 3
    }

    func getTotalCount() -> Int {
        return audioMaterials.count
    }

    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60
        let seconds = Int(time) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
