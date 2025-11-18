//
//  FlashCardStorage.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

enum StorageError: LocalizedError {
    case encodingFailed(Error)
    case decodingFailed(Error)
    case saveFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodingFailed(let error):
            return "Failed to encode data: \(error.localizedDescription)"
        case .decodingFailed(let error):
            return "Failed to decode data: \(error.localizedDescription)"
        case .saveFailed(let key):
            return "Failed to save data for key: \(key)"
        }
    }
}

final class FlashCardStorage: ObservableObject {
    static let shared = FlashCardStorage()

    @Published private(set) var groups: [WordGroup] = []
    @Published private(set) var cards: [FlashCard] = []
    @Published private(set) var lastError: StorageError?

    private let groupsKey = "flashcard_groups"
    private let cardsKey = "flashcard_cards"

    private init() {
        // Load data synchronously to avoid race conditions
        let (loadedGroups, loadedCards) = Self.loadDataFromUserDefaults()
        self.groups = loadedGroups
        self.cards = loadedCards

        // Add mock data if empty (deferred to avoid blocking init)
        if self.groups.isEmpty {
            Task { @MainActor in
                await self.setupMockData()
            }
        }
    }

    private static func loadDataFromUserDefaults() -> ([WordGroup], [FlashCard]) {
        let groupsKey = "flashcard_groups"
        let cardsKey = "flashcard_cards"

        let loadedGroups: [WordGroup]
        let loadedCards: [FlashCard]

        // Load groups with error handling
        if let groupsData = UserDefaults.standard.data(forKey: groupsKey) {
            do {
                loadedGroups = try JSONDecoder().decode([WordGroup].self, from: groupsData)
            } catch {
                print("⚠️ FlashCardStorage: Failed to decode groups - \(error.localizedDescription)")
                if AppConfiguration.enableLogging {
                    print("Corrupted data will be cleared. Starting fresh.")
                }
                // Clear corrupted data
                UserDefaults.standard.removeObject(forKey: groupsKey)
                loadedGroups = []
            }
        } else {
            loadedGroups = []
        }

        // Load cards with error handling
        if let cardsData = UserDefaults.standard.data(forKey: cardsKey) {
            do {
                loadedCards = try JSONDecoder().decode([FlashCard].self, from: cardsData)
            } catch {
                print("⚠️ FlashCardStorage: Failed to decode cards - \(error.localizedDescription)")
                if AppConfiguration.enableLogging {
                    print("Corrupted data will be cleared. Starting fresh.")
                }
                // Clear corrupted data
                UserDefaults.standard.removeObject(forKey: cardsKey)
                loadedCards = []
            }
        } else {
            loadedCards = []
        }

        return (loadedGroups, loadedCards)
    }

    // MARK: - Group Management

    func addGroup(_ group: WordGroup) async {
        // Update UI state on main thread
        await MainActor.run {
            self.groups.append(group)
        }
        // Save on background thread
        await saveGroups()
    }

    func deleteGroup(_ groupID: UUID) async {
        // Update UI state on main thread
        await MainActor.run {
            self.groups.removeAll { $0.id == groupID }
            self.cards.removeAll { $0.groupID == groupID }
        }
        // Save on background thread
        await saveGroups()
        await saveCards()
    }

    func getGroup(by id: UUID) async -> WordGroup? {
        await MainActor.run {
            self.groups.first { $0.id == id }
        }
    }

    // MARK: - Card Management

    func addCard(_ card: FlashCard) async {
        // Update UI state on main thread
        await MainActor.run {
            self.cards.append(card)
        }
        // Save on background thread
        await saveCards()
    }

    func updateCard(_ card: FlashCard) async {
        // Update UI state on main thread
        await MainActor.run {
            if let index = self.cards.firstIndex(where: { $0.id == card.id }) {
                self.cards[index] = card
            }
        }
        // Save on background thread
        await saveCards()
    }

    func deleteCard(_ cardID: UUID) async {
        // Update UI state on main thread
        await MainActor.run {
            self.cards.removeAll { $0.id == cardID }
        }
        // Save on background thread
        await saveCards()
    }

    func getCards(for groupID: UUID) async -> [FlashCard] {
        await MainActor.run {
            self.cards.filter { $0.groupID == groupID }
        }
    }

    @MainActor
    func getNewCardsCount() -> Int {
        self.cards.filter { $0.isNew }.count
    }

    @MainActor
    func getReviewCardsCount() -> Int {
        self.cards.filter { $0.needsReview }.count
    }

    // MARK: - Persistence

    private func saveGroups() async {
        let groupsCopy = await MainActor.run { self.groups }

        do {
            let encoded = try JSONEncoder().encode(groupsCopy)
            UserDefaults.standard.set(encoded, forKey: groupsKey)

            // Clear error on successful save
            await MainActor.run {
                self.lastError = nil
            }

            if AppConfiguration.enableLogging {
                print("✅ FlashCardStorage: Successfully saved \(groupsCopy.count) groups")
            }
        } catch {
            let storageError = StorageError.encodingFailed(error)
            await MainActor.run {
                self.lastError = storageError
            }
            print("❌ FlashCardStorage: Failed to save groups - \(error.localizedDescription)")
        }
    }

    private func saveCards() async {
        let cardsCopy = await MainActor.run { self.cards }

        do {
            let encoded = try JSONEncoder().encode(cardsCopy)
            UserDefaults.standard.set(encoded, forKey: cardsKey)

            // Clear error on successful save
            await MainActor.run {
                self.lastError = nil
            }

            if AppConfiguration.enableLogging {
                print("✅ FlashCardStorage: Successfully saved \(cardsCopy.count) cards")
            }
        } catch {
            let storageError = StorageError.encodingFailed(error)
            await MainActor.run {
                self.lastError = storageError
            }
            print("❌ FlashCardStorage: Failed to save cards - \(error.localizedDescription)")
        }
    }


    // MARK: - Mock Data

    private func setupMockData() async {
        let travelGroup = WordGroup(name: "Travel")
        let educationGroup = WordGroup(name: "Education")
        let cafeGroup = WordGroup(name: "Cafe")

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

        // Update UI state on main thread
        await MainActor.run {
            self.groups = [travelGroup, educationGroup, cafeGroup]
            self.cards = sampleCards
        }

        // Save on background thread
        await saveGroups()
        await saveCards()
    }
}
