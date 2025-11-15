//
//  FlashCardsTests.swift
//  EnglishAppTests
//
//  Created by Claude on 15/11/2025.
//

import XCTest
import SwiftUI
@testable import EnglishApp

@MainActor
final class FlashCardsTests: XCTestCase {

    // MARK: - Model Tests

    func testFlashCardInitialization() {
        // Given
        let groupID = UUID()

        // When
        let card = FlashCard(
            word: "Test",
            translation: "Тест",
            groupID: groupID,
            difficulty: .easy
        )

        // Then
        XCTAssertEqual(card.word, "Test")
        XCTAssertEqual(card.translation, "Тест")
        XCTAssertEqual(card.groupID, groupID)
        XCTAssertEqual(card.difficulty, .easy)
        XCTAssertTrue(card.isNew)
        XCTAssertFalse(card.needsReview)
    }

    func testWordGroupInitialization() {
        // When
        let group = WordGroup(name: "Travel")

        // Then
        XCTAssertEqual(group.name, "Travel")
        XCTAssertNotNil(group.id)
        XCTAssertNotNil(group.createdDate)
    }

    func testDifficultyLevelCases() {
        // Then
        XCTAssertEqual(DifficultyLevel.easy.rawValue, "Easy")
        XCTAssertEqual(DifficultyLevel.medium.rawValue, "Medium")
        XCTAssertEqual(DifficultyLevel.hard.rawValue, "Hard")
        XCTAssertEqual(DifficultyLevel.allCases.count, 3)
    }

    // MARK: - ReviewSession Tests

    func testReviewSessionInitialization() {
        // Given
        let groupID = UUID()
        let cards = [
            FlashCard(word: "Test1", translation: "Тест1", groupID: groupID),
            FlashCard(word: "Test2", translation: "Тест2", groupID: groupID)
        ]

        // When
        let session = ReviewSession(groupID: groupID, cards: cards)

        // Then
        XCTAssertEqual(session.groupID, groupID)
        XCTAssertEqual(session.cards.count, 2)
        XCTAssertEqual(session.currentIndex, 0)
        XCTAssertEqual(session.correctCount, 0)
        XCTAssertEqual(session.wrongCount, 0)
        XCTAssertFalse(session.showingTranslation)
        XCTAssertFalse(session.isComplete)
    }

    func testReviewSessionCurrentCard() {
        // Given
        let groupID = UUID()
        let cards = [
            FlashCard(word: "Test1", translation: "Тест1", groupID: groupID),
            FlashCard(word: "Test2", translation: "Тест2", groupID: groupID)
        ]
        let session = ReviewSession(groupID: groupID, cards: cards)

        // Then
        XCTAssertEqual(session.currentCard?.word, "Test1")
        XCTAssertEqual(session.remainingCards, 2)
    }

    func testReviewSessionMarkAsKnown() {
        // Given
        let groupID = UUID()
        let cards = [
            FlashCard(word: "Test1", translation: "Тест1", groupID: groupID),
            FlashCard(word: "Test2", translation: "Тест2", groupID: groupID)
        ]
        var session = ReviewSession(groupID: groupID, cards: cards)

        // When
        session.markAsKnown()

        // Then
        XCTAssertEqual(session.correctCount, 1)
        XCTAssertEqual(session.wrongCount, 0)
        XCTAssertEqual(session.currentIndex, 1)
        XCTAssertFalse(session.showingTranslation)
        XCTAssertEqual(session.currentCard?.word, "Test2")
    }

    func testReviewSessionMarkAsUnknown() {
        // Given
        let groupID = UUID()
        let cards = [
            FlashCard(word: "Test1", translation: "Тест1", groupID: groupID)
        ]
        var session = ReviewSession(groupID: groupID, cards: cards)

        // When
        session.markAsUnknown()

        // Then
        XCTAssertEqual(session.correctCount, 0)
        XCTAssertEqual(session.wrongCount, 1)
        XCTAssertEqual(session.currentIndex, 1)
    }

    func testReviewSessionFlipCard() {
        // Given
        let groupID = UUID()
        let cards = [FlashCard(word: "Test", translation: "Тест", groupID: groupID)]
        var session = ReviewSession(groupID: groupID, cards: cards)
        XCTAssertFalse(session.showingTranslation)

        // When
        session.flipCard()

        // Then
        XCTAssertTrue(session.showingTranslation)

        // When - flip again
        session.flipCard()

        // Then
        XCTAssertFalse(session.showingTranslation)
    }

    func testReviewSessionCompletion() {
        // Given
        let groupID = UUID()
        let cards = [
            FlashCard(word: "Test1", translation: "Тест1", groupID: groupID),
            FlashCard(word: "Test2", translation: "Тест2", groupID: groupID)
        ]
        var session = ReviewSession(groupID: groupID, cards: cards)

        // When - answer all cards
        session.markAsKnown()
        XCTAssertFalse(session.isComplete)

        session.markAsKnown()

        // Then
        XCTAssertTrue(session.isComplete)
        XCTAssertNil(session.currentCard)
        XCTAssertEqual(session.remainingCards, 0)
    }

    // MARK: - FlashCardStorage Tests

    func testFlashCardStorageSharedInstance() {
        // Then
        XCTAssertNotNil(FlashCardStorage.shared)
        XCTAssertTrue(FlashCardStorage.shared === FlashCardStorage.shared)
    }

    func testAddGroup() {
        // Given
        let storage = FlashCardStorage.shared
        let initialCount = storage.groups.count
        let newGroup = WordGroup(name: "Test Group")

        // When
        storage.addGroup(newGroup)

        // Then
        XCTAssertEqual(storage.groups.count, initialCount + 1)
        XCTAssertTrue(storage.groups.contains(where: { $0.id == newGroup.id }))

        // Cleanup
        storage.deleteGroup(newGroup.id)
    }

    func testAddCard() {
        // Given
        let storage = FlashCardStorage.shared
        let group = WordGroup(name: "Test Group")
        storage.addGroup(group)

        let initialCount = storage.cards.count
        let newCard = FlashCard(word: "Test", translation: "Тест", groupID: group.id)

        // When
        storage.addCard(newCard)

        // Then
        XCTAssertEqual(storage.cards.count, initialCount + 1)
        XCTAssertTrue(storage.cards.contains(where: { $0.id == newCard.id }))

        // Cleanup
        storage.deleteCard(newCard.id)
        storage.deleteGroup(group.id)
    }

    func testGetCardsForGroup() {
        // Given
        let storage = FlashCardStorage.shared
        let group1 = WordGroup(name: "Group 1")
        let group2 = WordGroup(name: "Group 2")
        storage.addGroup(group1)
        storage.addGroup(group2)

        let card1 = FlashCard(word: "Test1", translation: "Тест1", groupID: group1.id)
        let card2 = FlashCard(word: "Test2", translation: "Тест2", groupID: group1.id)
        let card3 = FlashCard(word: "Test3", translation: "Тест3", groupID: group2.id)

        storage.addCard(card1)
        storage.addCard(card2)
        storage.addCard(card3)

        // When
        let group1Cards = storage.getCards(for: group1.id)
        let group2Cards = storage.getCards(for: group2.id)

        // Then
        XCTAssertEqual(group1Cards.count, 2)
        XCTAssertEqual(group2Cards.count, 1)
        XCTAssertTrue(group1Cards.contains(where: { $0.id == card1.id }))
        XCTAssertTrue(group1Cards.contains(where: { $0.id == card2.id }))
        XCTAssertTrue(group2Cards.contains(where: { $0.id == card3.id }))

        // Cleanup
        storage.deleteCard(card1.id)
        storage.deleteCard(card2.id)
        storage.deleteCard(card3.id)
        storage.deleteGroup(group1.id)
        storage.deleteGroup(group2.id)
    }

    func testDeleteGroup() {
        // Given
        let storage = FlashCardStorage.shared
        let group = WordGroup(name: "Test Group")
        storage.addGroup(group)

        let card = FlashCard(word: "Test", translation: "Тест", groupID: group.id)
        storage.addCard(card)

        // When
        storage.deleteGroup(group.id)

        // Then
        XCTAssertFalse(storage.groups.contains(where: { $0.id == group.id }))
        XCTAssertFalse(storage.cards.contains(where: { $0.groupID == group.id }))
    }

    func testGetNewCardsCount() {
        // Given
        let storage = FlashCardStorage.shared
        let group = WordGroup(name: "Test Group")
        storage.addGroup(group)

        let newCard = FlashCard(word: "New", translation: "Новый", groupID: group.id, isNew: true)
        let oldCard = FlashCard(word: "Old", translation: "Старый", groupID: group.id, isNew: false)

        storage.addCard(newCard)
        storage.addCard(oldCard)

        let initialNewCount = storage.getNewCardsCount()

        // Then
        XCTAssertGreaterThanOrEqual(initialNewCount, 1)

        // Cleanup
        storage.deleteCard(newCard.id)
        storage.deleteCard(oldCard.id)
        storage.deleteGroup(group.id)
    }

    func testGetReviewCardsCount() {
        // Given
        let storage = FlashCardStorage.shared
        let group = WordGroup(name: "Test Group")
        storage.addGroup(group)

        let reviewCard = FlashCard(word: "Review", translation: "Обзор", groupID: group.id, needsReview: true)
        let normalCard = FlashCard(word: "Normal", translation: "Обычный", groupID: group.id, needsReview: false)

        storage.addCard(reviewCard)
        storage.addCard(normalCard)

        let initialReviewCount = storage.getReviewCardsCount()

        // Then
        XCTAssertGreaterThanOrEqual(initialReviewCount, 1)

        // Cleanup
        storage.deleteCard(reviewCard.id)
        storage.deleteCard(normalCard.id)
        storage.deleteGroup(group.id)
    }

    // MARK: - AddWordViewModel Tests

    func testAddWordViewModelInitialization() {
        // When
        let viewModel = AddWordViewModel()

        // Then
        XCTAssertTrue(viewModel.word.isEmpty)
        XCTAssertTrue(viewModel.translation.isEmpty)
        XCTAssertEqual(viewModel.selectedDifficulty, .medium)
        XCTAssertFalse(viewModel.groups.isEmpty)
    }

    func testAddWordViewModelValidation() {
        // Given
        let viewModel = AddWordViewModel()

        // Initially invalid
        XCTAssertFalse(viewModel.isValid)

        // When - add word only
        viewModel.word = "Test"
        XCTAssertFalse(viewModel.isValid)

        // When - add translation
        viewModel.translation = "Тест"

        // Then - should be valid if group is selected
        if viewModel.selectedGroup != nil {
            XCTAssertTrue(viewModel.isValid)
        }
    }

    func testAddWordViewModelClearForm() {
        // Given
        let viewModel = AddWordViewModel()
        viewModel.word = "Test"
        viewModel.translation = "Тест"
        viewModel.exampleSentence = "Example"
        viewModel.pronunciation = "[test]"
        viewModel.selectedDifficulty = .hard

        // When
        viewModel.clearForm()

        // Then
        XCTAssertTrue(viewModel.word.isEmpty)
        XCTAssertTrue(viewModel.translation.isEmpty)
        XCTAssertTrue(viewModel.exampleSentence.isEmpty)
        XCTAssertTrue(viewModel.pronunciation.isEmpty)
        XCTAssertEqual(viewModel.selectedDifficulty, .medium)
    }

    // MARK: - Screen Enum Tests

    func testScreenFlashCardsCase() {
        // Test that flashcards cases are part of Screen enum
        let flashCardsScreen = Screen.flashCards
        let addWordScreen = Screen.addNewWord
        let addGroupScreen = Screen.addNewWordsGroup
        let memoriseScreen = Screen.memoriseWords(groupID: UUID())

        // These should all be valid Screen cases
        XCTAssertNotNil(flashCardsScreen)
        XCTAssertNotNil(addWordScreen)
        XCTAssertNotNil(addGroupScreen)
        XCTAssertNotNil(memoriseScreen)
    }

    func testScreenHashable() {
        // Test flashcards screens are hashable
        let groupID = UUID()
        let screen1 = Screen.memoriseWords(groupID: groupID)
        let screen2 = Screen.memoriseWords(groupID: groupID)
        let screen3 = Screen.memoriseWords(groupID: UUID())

        XCTAssertEqual(screen1, screen2)
        XCTAssertNotEqual(screen1, screen3)
    }
}
