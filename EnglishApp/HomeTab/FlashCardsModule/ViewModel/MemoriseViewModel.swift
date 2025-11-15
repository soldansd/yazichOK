//
//  MemoriseViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

@MainActor
class MemoriseViewModel: ObservableObject {
    @Published var session: ReviewSession?
    @Published var showingStatistics = false
    @Published var formattedTime: String = "0:00"

    private let storage = FlashCardStorage.shared
    private let groupID: UUID
    private var timer: Timer?

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
        startTimer()
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
            stopTimer()
            showingStatistics = true
        }
    }

    func restartSession() {
        showingStatistics = false
        startSession()
    }

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            self?.updateFormattedTime()
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func updateFormattedTime() {
        guard let elapsed = session?.elapsedTime else {
            formattedTime = "0:00"
            return
        }
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        formattedTime = String(format: "%d:%02d", minutes, seconds)
    }

    deinit {
        stopTimer()
    }
}
