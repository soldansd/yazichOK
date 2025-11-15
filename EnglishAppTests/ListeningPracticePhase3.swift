//
//  ListeningPracticePhase3.swift
//  EnglishAppTests
//
//  Created by Claude on 15/11/2025.
//

import XCTest
@testable import EnglishApp

final class ListeningPracticePhase3: XCTestCase {

    // MARK: - AudioMaterial Model Tests

    func testAudioMaterialInitialization() {
        let audio = AudioMaterial(
            id: "test-audio",
            title: "Test Audio",
            filename: "test.mp3",
            duration: 180,
            difficulty: .intermediate,
            isLocked: false,
            category: "Test"
        )

        XCTAssertEqual(audio.id, "test-audio")
        XCTAssertEqual(audio.title, "Test Audio")
        XCTAssertEqual(audio.filename, "test.mp3")
        XCTAssertNil(audio.url)
        XCTAssertEqual(audio.duration, 180)
        XCTAssertEqual(audio.difficulty, .intermediate)
        XCTAssertFalse(audio.isLocked)
        XCTAssertEqual(audio.category, "Test")
    }

    func testAudioMaterialDurationFormatting() {
        let audio1 = AudioMaterial(id: "1", title: "Audio 1", duration: 225, difficulty: .beginner) // 3:45
        let audio2 = AudioMaterial(id: "2", title: "Audio 2", duration: 90, difficulty: .beginner) // 1:30
        let audio3 = AudioMaterial(id: "3", title: "Audio 3", duration: 45, difficulty: .beginner) // 0:45

        XCTAssertEqual(audio1.durationFormatted, "3:45 mins")
        XCTAssertEqual(audio2.durationFormatted, "1:30 mins")
        XCTAssertEqual(audio3.durationFormatted, "45 secs")
    }

    func testAudioMaterialMockData() {
        XCTAssertFalse(AudioMaterial.mockAudioMaterials.isEmpty)
        XCTAssertTrue(AudioMaterial.mockAudioMaterials.count >= 5)

        let businessMeeting = AudioMaterial.mockAudioMaterials.first { $0.id == "business-meeting" }
        XCTAssertNotNil(businessMeeting)
        XCTAssertEqual(businessMeeting?.title, "Business Meeting Discussion")
        XCTAssertFalse(businessMeeting?.isLocked ?? true)
    }

    func testAudioMaterialHashable() {
        let audio1 = AudioMaterial(id: "1", title: "Audio 1", duration: 100, difficulty: .beginner)
        let audio2 = AudioMaterial(id: "1", title: "Audio 1", duration: 100, difficulty: .beginner)
        let audio3 = AudioMaterial(id: "2", title: "Audio 2", duration: 100, difficulty: .beginner)

        XCTAssertEqual(audio1, audio2)
        XCTAssertNotEqual(audio1, audio3)
    }

    func testAudioMaterialDifficultyLevels() {
        XCTAssertEqual(AudioMaterial.DifficultyLevel.beginner.rawValue, "Beginner")
        XCTAssertEqual(AudioMaterial.DifficultyLevel.intermediate.rawValue, "Intermediate")
        XCTAssertEqual(AudioMaterial.DifficultyLevel.advanced.rawValue, "Advanced")
    }

    // MARK: - AudioPlayerManager Tests

    func testAudioPlayerManagerSingleton() {
        let instance1 = AudioPlayerManager.shared
        let instance2 = AudioPlayerManager.shared

        XCTAssertTrue(instance1 === instance2)
    }

    func testAudioPlayerManagerInitialState() {
        let player = AudioPlayerManager.shared
        player.reset()

        XCTAssertFalse(player.isPlaying)
        XCTAssertEqual(player.currentTime, 0)
        XCTAssertEqual(player.duration, 0)
        XCTAssertFalse(player.isLoading)
        XCTAssertNil(player.currentAudio)
    }

    func testAudioPlayerManagerLoadAudio() async {
        let player = AudioPlayerManager.shared
        let audio = AudioMaterial.mockAudioMaterials[0]

        await player.loadAudio(audio)

        XCTAssertFalse(player.isLoading)
        XCTAssertEqual(player.currentAudio?.id, audio.id)
        XCTAssertEqual(player.duration, audio.duration)
    }

    func testAudioPlayerManagerPlayPause() async {
        let player = AudioPlayerManager.shared
        let audio = AudioMaterial.mockAudioMaterials[0]

        await player.loadAudio(audio)

        XCTAssertFalse(player.isPlaying)

        player.play()
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertTrue(player.isPlaying)

        player.pause()
        try? await Task.sleep(nanoseconds: 100_000_000)
        XCTAssertFalse(player.isPlaying)
    }

    func testAudioPlayerManagerSeekBackward() async {
        let player = AudioPlayerManager.shared
        let audio = AudioMaterial.mockAudioMaterials[0]

        await player.loadAudio(audio)

        // Manually set current time
        player.play()
        try? await Task.sleep(nanoseconds: 200_000_000)

        let timeBefore = player.currentTime
        player.seekBackward(by: 10)
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertLessThan(player.currentTime, timeBefore)
    }

    func testAudioPlayerManagerSeekForward() async {
        let player = AudioPlayerManager.shared
        let audio = AudioMaterial.mockAudioMaterials[0]

        await player.loadAudio(audio)

        let timeBefore = player.currentTime
        player.seekForward(by: 10)
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertGreaterThanOrEqual(player.currentTime, timeBefore)
    }

    func testAudioPlayerManagerReset() async {
        let player = AudioPlayerManager.shared
        let audio = AudioMaterial.mockAudioMaterials[0]

        await player.loadAudio(audio)
        player.play()
        try? await Task.sleep(nanoseconds: 100_000_000)

        player.reset()
        try? await Task.sleep(nanoseconds: 100_000_000)

        XCTAssertFalse(player.isPlaying)
        XCTAssertEqual(player.currentTime, 0)
        XCTAssertEqual(player.duration, 0)
        XCTAssertNil(player.currentAudio)
    }

    // MARK: - ListeningPracticeViewModel Tests

    @MainActor
    func testListeningPracticeViewModelInitialization() {
        let viewModel = ListeningPracticeViewModel()

        XCTAssertFalse(viewModel.audioMaterials.isEmpty)
        XCTAssertNotNil(viewModel.currentAudio)
    }

    @MainActor
    func testListeningPracticeViewModelAutoSelectFirstUnlockedAudio() {
        let viewModel = ListeningPracticeViewModel()

        XCTAssertNotNil(viewModel.currentAudio)
        XCTAssertFalse(viewModel.currentAudio?.isLocked ?? true)
    }

    @MainActor
    func testListeningPracticeViewModelSelectAudio() async {
        let viewModel = ListeningPracticeViewModel()
        let audioToSelect = viewModel.audioMaterials.first { $0.id == "travel-dialogue" && !$0.isLocked }

        guard let audio = audioToSelect else {
            XCTFail("Test audio not found")
            return
        }

        viewModel.selectAudio(audio)

        XCTAssertEqual(viewModel.currentAudio?.id, audio.id)
    }

    @MainActor
    func testListeningPracticeViewModelCannotSelectLockedAudio() {
        let viewModel = ListeningPracticeViewModel()
        let lockedAudio = viewModel.audioMaterials.first { $0.isLocked }

        guard let audio = lockedAudio else {
            XCTFail("No locked audio found")
            return
        }

        let previousAudio = viewModel.currentAudio
        viewModel.selectAudio(audio)

        XCTAssertEqual(viewModel.currentAudio?.id, previousAudio?.id)
    }

    @MainActor
    func testListeningPracticeViewModelUpcomingAudio() {
        let viewModel = ListeningPracticeViewModel()

        XCTAssertFalse(viewModel.upcomingAudio.isEmpty)

        // Upcoming should not include current audio
        if let current = viewModel.currentAudio {
            XCTAssertFalse(viewModel.upcomingAudio.contains { $0.id == current.id })
        }
    }

    @MainActor
    func testListeningPracticeViewModelTogglePlayPause() async {
        let viewModel = ListeningPracticeViewModel()
        let player = AudioPlayerManager.shared

        // Ensure audio is loaded
        try? await Task.sleep(nanoseconds: 600_000_000)

        XCTAssertFalse(player.isPlaying)

        viewModel.togglePlayPause()
        XCTAssertTrue(player.isPlaying)

        viewModel.togglePlayPause()
        XCTAssertFalse(player.isPlaying)
    }

    @MainActor
    func testListeningPracticeViewModelSeekBackward() async {
        let viewModel = ListeningPracticeViewModel()
        let player = AudioPlayerManager.shared

        try? await Task.sleep(nanoseconds: 600_000_000)

        player.play()
        try? await Task.sleep(nanoseconds: 200_000_000)

        let timeBefore = player.currentTime
        viewModel.seekBackward()

        XCTAssertLessThanOrEqual(player.currentTime, timeBefore)
    }

    @MainActor
    func testListeningPracticeViewModelSeekForward() async {
        let viewModel = ListeningPracticeViewModel()
        let player = AudioPlayerManager.shared

        try? await Task.sleep(nanoseconds: 600_000_000)

        let timeBefore = player.currentTime
        viewModel.seekForward()

        XCTAssertGreaterThanOrEqual(player.currentTime, timeBefore)
    }

    @MainActor
    func testListeningPracticeViewModelCompletedCount() {
        let viewModel = ListeningPracticeViewModel()

        let completed = viewModel.getCompletedCount()
        XCTAssertGreaterThanOrEqual(completed, 0)
    }

    @MainActor
    func testListeningPracticeViewModelTotalCount() {
        let viewModel = ListeningPracticeViewModel()

        let total = viewModel.getTotalCount()
        XCTAssertEqual(total, viewModel.audioMaterials.count)
        XCTAssertGreaterThan(total, 0)
    }

    @MainActor
    func testListeningPracticeViewModelFormatTime() {
        let viewModel = ListeningPracticeViewModel()

        XCTAssertEqual(viewModel.formatTime(0), "0:00")
        XCTAssertEqual(viewModel.formatTime(45), "0:45")
        XCTAssertEqual(viewModel.formatTime(90), "1:30")
        XCTAssertEqual(viewModel.formatTime(225), "3:45")
        XCTAssertEqual(viewModel.formatTime(3661), "61:01")
    }

    // MARK: - Integration Tests

    @MainActor
    func testFullListeningFlow() async {
        let viewModel = ListeningPracticeViewModel()
        let player = AudioPlayerManager.shared

        // Initial state
        XCTAssertNotNil(viewModel.currentAudio)
        XCTAssertFalse(player.isPlaying)

        // Wait for audio to load
        try? await Task.sleep(nanoseconds: 600_000_000)

        // Play audio
        viewModel.togglePlayPause()
        XCTAssertTrue(player.isPlaying)

        // Wait a bit
        try? await Task.sleep(nanoseconds: 200_000_000)

        // Seek forward
        viewModel.seekForward()
        let timeAfterSeek = player.currentTime
        XCTAssertGreaterThan(timeAfterSeek, 0)

        // Pause
        viewModel.togglePlayPause()
        XCTAssertFalse(player.isPlaying)

        // Select different audio
        if let nextAudio = viewModel.upcomingAudio.first(where: { !$0.isLocked }) {
            viewModel.selectAudio(nextAudio)
            XCTAssertEqual(viewModel.currentAudio?.id, nextAudio.id)
        }
    }

    func testAudioMaterialsHaveValidData() {
        let materials = AudioMaterial.mockAudioMaterials

        for material in materials {
            XCTAssertFalse(material.id.isEmpty)
            XCTAssertFalse(material.title.isEmpty)
            XCTAssertGreaterThan(material.duration, 0)
            XCTAssertFalse(material.category.isEmpty)
            XCTAssertFalse(material.durationFormatted.isEmpty)

            // Should have either filename or URL
            XCTAssertTrue(material.filename != nil || material.url != nil)
        }
    }

    func testLockedAndUnlockedAudioMix() {
        let materials = AudioMaterial.mockAudioMaterials

        let locked = materials.filter { $0.isLocked }
        let unlocked = materials.filter { !$0.isLocked }

        XCTAssertFalse(locked.isEmpty, "Should have some locked audio")
        XCTAssertFalse(unlocked.isEmpty, "Should have some unlocked audio")
    }

    func testAudioPlayerManagerHandlesMultipleLoads() async {
        let player = AudioPlayerManager.shared
        let audio1 = AudioMaterial.mockAudioMaterials[0]
        let audio2 = AudioMaterial.mockAudioMaterials[4]

        await player.loadAudio(audio1)

        XCTAssertEqual(player.currentAudio?.id, audio1.id)

        await player.loadAudio(audio2)

        XCTAssertEqual(player.currentAudio?.id, audio2.id)
        XCTAssertFalse(player.isPlaying) // Should reset when loading new audio
    }
}
