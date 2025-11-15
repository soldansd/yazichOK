//
//  FlashCardsViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

class FlashCardsViewModel: ObservableObject {
    @Published var groups: [WordGroup] = []
    @Published var showingAddGroup = false

    private let storage = FlashCardStorage.shared

    init() {
        Task {
            await loadGroups()
        }
    }

    func loadGroups() async {
        let loadedGroups = await MainActor.run { storage.groups }
        await MainActor.run {
            self.groups = loadedGroups
        }
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
