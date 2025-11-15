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
        loadGroups()
    }

    func loadGroups() {
        groups = storage.groups
    }

    func getCardCount(for groupID: UUID) -> Int {
        storage.getCards(for: groupID).count
    }

    func deleteGroup(_ group: WordGroup) {
        storage.deleteGroup(group.id)
        loadGroups()
    }
}
