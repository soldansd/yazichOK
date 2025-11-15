//
//  TabNavigationTests.swift
//  EnglishAppTests
//
//  Created by Claude on 15/11/2025.
//

import XCTest
import SwiftUI
@testable import EnglishApp

final class TabNavigationTests: XCTestCase {

    // MARK: - LearnCoordinator Tests

    func testLearnCoordinatorPush() {
        // Given
        let coordinator = LearnCoordinator()
        XCTAssertTrue(coordinator.path.isEmpty, "Path should be empty initially")

        // When
        coordinator.push(.grammarTopics)

        // Then
        XCTAssertEqual(coordinator.path.count, 1, "Path should contain one screen")
    }

    func testLearnCoordinatorPop() {
        // Given
        let coordinator = LearnCoordinator()
        coordinator.push(.grammarTopics)
        coordinator.push(.listeningPractice)
        XCTAssertEqual(coordinator.path.count, 2, "Path should contain two screens")

        // When
        coordinator.pop()

        // Then
        XCTAssertEqual(coordinator.path.count, 1, "Path should contain one screen after pop")
    }

    func testLearnCoordinatorPopToRoot() {
        // Given
        let coordinator = LearnCoordinator()
        coordinator.push(.grammarTopics)
        coordinator.push(.listeningPractice)
        coordinator.push(.grammarTest(topicID: "test-1"))
        XCTAssertEqual(coordinator.path.count, 3, "Path should contain three screens")

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertTrue(coordinator.path.isEmpty, "Path should be empty after popToRoot")
    }

    func testLearnCoordinatorPopEmptyPath() {
        // Given
        let coordinator = LearnCoordinator()
        XCTAssertTrue(coordinator.path.isEmpty, "Path should be empty initially")

        // When - Should not crash when popping empty path
        coordinator.pop()

        // Then
        XCTAssertTrue(coordinator.path.isEmpty, "Path should still be empty")
    }

    // MARK: - HomeCoordinator Tests (verify existing functionality still works)

    func testHomeCoordinatorPush() {
        // Given
        let coordinator = HomeCoordinator()
        XCTAssertTrue(coordinator.path.isEmpty, "Path should be empty initially")

        // When
        coordinator.push(.topicsList)

        // Then
        XCTAssertEqual(coordinator.path.count, 1, "Path should contain one screen")
    }

    func testHomeCoordinatorMultiplePushes() {
        // Given
        let coordinator = HomeCoordinator()

        // When
        coordinator.push(.topicsList)
        coordinator.push(.audioRecording(topicID: 123))
        coordinator.push(.articlesPreview)

        // Then
        XCTAssertEqual(coordinator.path.count, 3, "Path should contain three screens")
    }

    func testHomeCoordinatorPopToRoot() {
        // Given
        let coordinator = HomeCoordinator()
        coordinator.push(.topicsList)
        coordinator.push(.articlesPreview)
        coordinator.push(.article(id: 1))

        // When
        coordinator.popToRoot()

        // Then
        XCTAssertTrue(coordinator.path.isEmpty, "Path should be empty after popToRoot")
    }

    // MARK: - LearnScreen Hashable Tests

    func testLearnScreenEquality() {
        // Test that same screens are equal
        let screen1 = LearnScreen.grammarTopics
        let screen2 = LearnScreen.grammarTopics
        XCTAssertEqual(screen1, screen2, "Same screens should be equal")

        // Test that different screens are not equal
        let screen3 = LearnScreen.listeningPractice
        XCTAssertNotEqual(screen1, screen3, "Different screens should not be equal")

        // Test screens with associated values
        let test1 = LearnScreen.grammarTest(topicID: "topic1")
        let test2 = LearnScreen.grammarTest(topicID: "topic1")
        let test3 = LearnScreen.grammarTest(topicID: "topic2")

        XCTAssertEqual(test1, test2, "Same tests should be equal")
        XCTAssertNotEqual(test1, test3, "Tests with different IDs should not be equal")
    }

    func testLearnScreenHashable() {
        // Test that screens can be used in a Set
        var screenSet = Set<LearnScreen>()
        screenSet.insert(.grammarTopics)
        screenSet.insert(.grammarTopics) // Duplicate
        screenSet.insert(.listeningPractice)

        XCTAssertEqual(screenSet.count, 2, "Set should contain only unique screens")
    }
}
