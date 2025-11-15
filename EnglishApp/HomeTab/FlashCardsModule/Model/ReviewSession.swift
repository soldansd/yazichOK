//
//  ReviewSession.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct ReviewSession {
    var groupID: UUID
    var cards: [FlashCard]
    var currentIndex: Int
    var correctCount: Int
    var wrongCount: Int
    var startTime: Date
    var showingTranslation: Bool

    var currentCard: FlashCard? {
        guard currentIndex < cards.count else { return nil }
        return cards[currentIndex]
    }

    var remainingCards: Int {
        cards.count - currentIndex
    }

    var elapsedTime: TimeInterval {
        Date().timeIntervalSince(startTime)
    }

    var isComplete: Bool {
        currentIndex >= cards.count
    }

    init(groupID: UUID, cards: [FlashCard]) {
        self.groupID = groupID
        self.cards = cards
        self.currentIndex = 0
        self.correctCount = 0
        self.wrongCount = 0
        self.startTime = Date()
        self.showingTranslation = false
    }

    mutating func markAsKnown() {
        correctCount += 1
        showingTranslation = false
        currentIndex += 1
    }

    mutating func markAsUnknown() {
        wrongCount += 1
        showingTranslation = false
        currentIndex += 1
    }

    mutating func flipCard() {
        showingTranslation.toggle()
    }
}
