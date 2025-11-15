//
//  MemoriseViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

class MemoriseViewModel: ObservableObject {
    @Published var session: ReviewSession?
    @Published var showingStatistics = false

    private let storage = FlashCardStorage.shared
    private let groupID: UUID

    init(groupID: UUID) {
        self.groupID = groupID
        startSession()
    }

    func startSession() {
        let cards = storage.getCards(for: groupID)
        guard !cards.isEmpty else {
            showingStatistics = true
            return
        }
        session = ReviewSession(groupID: groupID, cards: cards)
    }

    func flipCard() {
        session?.flipCard()
    }

    func markAsKnown() {
        session?.markAsKnown()
        checkSessionComplete()
    }

    func markAsUnknown() {
        session?.markAsUnknown()
        checkSessionComplete()
    }

    private func checkSessionComplete() {
        if session?.isComplete == true {
            showingStatistics = true
        }
    }

    func restartSession() {
        showingStatistics = false
        startSession()
    }

    var formattedTime: String {
        guard let elapsed = session?.elapsedTime else { return "0:00" }
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%d:%02d", minutes, seconds)
    }
}
