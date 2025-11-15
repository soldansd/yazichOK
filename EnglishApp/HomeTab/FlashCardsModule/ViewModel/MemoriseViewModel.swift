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
    @Published var formattedTime: String = "0:00"

    private let storage = FlashCardStorage.shared
    private let groupID: UUID
    private var timer: Timer?

    init(groupID: UUID) {
        self.groupID = groupID
        Task {
            await startSession()
        }
    }

    func startSession() async {
        let cards = await storage.getCards(for: groupID)
        await MainActor.run {
            guard !cards.isEmpty else {
                self.showingStatistics = true
                return
            }
            self.session = ReviewSession(groupID: self.groupID, cards: cards)
            self.startTimer()
        }
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
        Task {
            await startSession()
        }
    }

    @MainActor
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
        timer?.invalidate()
        timer = nil
    }
}
