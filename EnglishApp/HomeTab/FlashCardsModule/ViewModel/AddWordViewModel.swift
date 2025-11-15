//
//  AddWordViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

class AddWordViewModel: ObservableObject {
    @Published var word = ""
    @Published var translation = ""
    @Published var exampleSentence = ""
    @Published var pronunciation = ""
    @Published var selectedGroup: WordGroup?
    @Published var selectedDifficulty: DifficultyLevel = .medium
    @Published var groups: [WordGroup] = []

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
            if self.selectedGroup == nil {
                self.selectedGroup = loadedGroups.first
            }
        }
    }

    var isValid: Bool {
        !word.isEmpty && !translation.isEmpty && selectedGroup != nil
    }

    func saveCard() async {
        guard isValid, let group = selectedGroup else { return }

        let newCard = FlashCard(
            word: word.trimmingCharacters(in: .whitespacesAndNewlines),
            translation: translation.trimmingCharacters(in: .whitespacesAndNewlines),
            exampleSentence: exampleSentence.trimmingCharacters(in: .whitespacesAndNewlines),
            pronunciation: pronunciation.trimmingCharacters(in: .whitespacesAndNewlines),
            groupID: group.id,
            difficulty: selectedDifficulty
        )

        await storage.addCard(newCard)
    }

    func clearForm() {
        word = ""
        translation = ""
        exampleSentence = ""
        pronunciation = ""
        selectedDifficulty = .medium
    }
}
