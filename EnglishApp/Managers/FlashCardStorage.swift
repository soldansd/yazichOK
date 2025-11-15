//
//  FlashCardStorage.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

final class FlashCardStorage: ObservableObject {
    static let shared = FlashCardStorage()

    @Published private(set) var groups: [WordGroup] = []
    @Published private(set) var cards: [FlashCard] = []

    private let groupsKey = "flashcard_groups"
    private let cardsKey = "flashcard_cards"

    private init() {
        loadData()
        // Add mock data if empty
        if groups.isEmpty {
            setupMockData()
        }
    }

    // MARK: - Group Management

    func addGroup(_ group: WordGroup) {
        groups.append(group)
        saveGroups()
    }

    func deleteGroup(_ groupID: UUID) {
        groups.removeAll { $0.id == groupID }
        cards.removeAll { $0.groupID == groupID }
        saveGroups()
        saveCards()
    }

    func getGroup(by id: UUID) -> WordGroup? {
        groups.first { $0.id == id }
    }

    // MARK: - Card Management

    func addCard(_ card: FlashCard) {
        cards.append(card)
        saveCards()
    }

    func updateCard(_ card: FlashCard) {
        if let index = cards.firstIndex(where: { $0.id == card.id }) {
            cards[index] = card
            saveCards()
        }
    }

    func deleteCard(_ cardID: UUID) {
        cards.removeAll { $0.id == cardID }
        saveCards()
    }

    func getCards(for groupID: UUID) -> [FlashCard] {
        cards.filter { $0.groupID == groupID }
    }

    func getNewCardsCount() -> Int {
        cards.filter { $0.isNew }.count
    }

    func getReviewCardsCount() -> Int {
        cards.filter { $0.needsReview }.count
    }

    // MARK: - Persistence

    private func saveGroups() {
        if let encoded = try? JSONEncoder().encode(groups) {
            UserDefaults.standard.set(encoded, forKey: groupsKey)
        }
    }

    private func saveCards() {
        if let encoded = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(encoded, forKey: cardsKey)
        }
    }

    private func loadData() {
        if let groupsData = UserDefaults.standard.data(forKey: groupsKey),
           let decodedGroups = try? JSONDecoder().decode([WordGroup].self, from: groupsData) {
            groups = decodedGroups
        }

        if let cardsData = UserDefaults.standard.data(forKey: cardsKey),
           let decodedCards = try? JSONDecoder().decode([FlashCard].self, from: cardsData) {
            cards = decodedCards
        }
    }

    // MARK: - Mock Data

    private func setupMockData() {
        let travelGroup = WordGroup(name: "Travel")
        let educationGroup = WordGroup(name: "Education")
        let cafeGroup = WordGroup(name: "Cafe")

        groups = [travelGroup, educationGroup, cafeGroup]
        saveGroups()

        // Add sample cards
        let sampleCards: [FlashCard] = [
            FlashCard(word: "Adventure", translation: "Приключение", exampleSentence: "Life is an adventure.", pronunciation: "[ədˈventʃər]", groupID: travelGroup.id, difficulty: .medium, isNew: true),
            FlashCard(word: "Journey", translation: "Путешествие", exampleSentence: "We had a long journey.", pronunciation: "[ˈdʒɜːrni]", groupID: travelGroup.id, difficulty: .easy, isNew: true),
            FlashCard(word: "Destination", translation: "Место назначения", exampleSentence: "What is your destination?", pronunciation: "[ˌdestɪˈneɪʃn]", groupID: travelGroup.id, difficulty: .hard, isNew: true),
            FlashCard(word: "Education", translation: "Образование", exampleSentence: "Education is important.", pronunciation: "[ˌedʒuˈkeɪʃn]", groupID: educationGroup.id, difficulty: .medium, needsReview: true),
            FlashCard(word: "Knowledge", translation: "Знание", exampleSentence: "Knowledge is power.", pronunciation: "[ˈnɑːlɪdʒ]", groupID: educationGroup.id, difficulty: .hard, needsReview: true),
            FlashCard(word: "Coffee", translation: "Кофе", exampleSentence: "I'd like a coffee, please.", pronunciation: "[ˈkɔːfi]", groupID: cafeGroup.id, difficulty: .easy, isNew: true),
            FlashCard(word: "Menu", translation: "Меню", exampleSentence: "Can I see the menu?", pronunciation: "[ˈmenjuː]", groupID: cafeGroup.id, difficulty: .easy, isNew: true),
        ]

        cards = sampleCards
        saveCards()
    }
}
