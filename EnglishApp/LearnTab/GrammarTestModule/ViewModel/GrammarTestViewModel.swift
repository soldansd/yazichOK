//
//  GrammarTestViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

@MainActor
class GrammarTestViewModel: ObservableObject {
    @Published var session: TestSession
    @Published var selectedAnswerIndex: Int? = nil
    @Published var hasCheckedAnswer: Bool = false
    @Published var showingResult: Bool = false

    var currentQuestion: TestQuestion? {
        guard session.currentQuestionIndex < session.questions.count else { return nil }
        return session.questions[session.currentQuestionIndex]
    }

    var isAnswerCorrect: Bool {
        guard let selectedAnswerIndex = selectedAnswerIndex,
              let currentQuestion = currentQuestion else { return false }
        return selectedAnswerIndex == currentQuestion.correctAnswerIndex
    }

    var canCheckAnswer: Bool {
        selectedAnswerIndex != nil && !hasCheckedAnswer
    }

    init(topicID: String, topicName: String) {
        let questions = TestQuestion.mockQuestions(for: topicID)
        self.session = TestSession(topicID: topicID, topicName: topicName, questions: questions)
    }

    func selectAnswer(_ index: Int) {
        guard !hasCheckedAnswer else { return }
        selectedAnswerIndex = index
    }

    func checkAnswer() {
        guard let selectedAnswerIndex = selectedAnswerIndex,
              !hasCheckedAnswer else { return }

        hasCheckedAnswer = true
        showingResult = true

        // Record the answer
        session.recordAnswer(selectedIndex: selectedAnswerIndex, isCorrect: isAnswerCorrect)
    }

    func continueToNextQuestion() {
        session.moveToNextQuestion()
        resetForNextQuestion()
    }

    private func resetForNextQuestion() {
        selectedAnswerIndex = nil
        hasCheckedAnswer = false
        showingResult = false
    }

    func getProgressPercentage() -> Double {
        guard session.totalQuestions > 0 else { return 0 }
        return Double(session.currentQuestionIndex + 1) / Double(session.totalQuestions)
    }
}
