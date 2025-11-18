//
//  FlashCardsViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class FlashCardsViewModel: ObservableObject {
    @Published var groups: [WordGroup] = []
    @Published var cardCounts: [UUID: Int] = [:]
    @Published var showingAddGroup = false

    private let storage = FlashCardStorage.shared

    init() {
        // Don't spawn Task in init - use .task modifier in view instead
    }

    func loadGroups() async {
        // Already on main thread due to @MainActor
        let loadedGroups = storage.groups

        // Load card counts for all groups
        var counts: [UUID: Int] = [:]
        for group in loadedGroups {
            let cards = await storage.getCards(for: group.id)
            counts[group.id] = cards.count
        }

        // Already on main thread - direct assignment
        self.groups = loadedGroups
        self.cardCounts = counts
    }

    func getCardCount(for groupID: UUID) async -> Int {
        let cards = await storage.getCards(for: groupID)
        return cards.count
    }

    func deleteGroup(_ group: WordGroup) async {
        await storage.deleteGroup(group.id)
        await loadGroups()
    }
}
