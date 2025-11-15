//
//  TestSession.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct TestSession {
    let topicID: String
    let topicName: String
    var currentQuestionIndex: Int
    var answers: [TestAnswer]
    var questions: [TestQuestion]

    var totalQuestions: Int {
        questions.count
    }

    var correctAnswersCount: Int {
        answers.filter { $0.isCorrect }.count
    }

    var incorrectAnswersCount: Int {
        answers.filter { !$0.isCorrect }.count
    }

    var isCompleted: Bool {
        currentQuestionIndex >= questions.count
    }

    init(topicID: String, topicName: String, questions: [TestQuestion]) {
        self.topicID = topicID
        self.topicName = topicName
        self.currentQuestionIndex = 0
        self.answers = []
        self.questions = questions
    }

    mutating func recordAnswer(selectedIndex: Int, isCorrect: Bool) {
        let answer = TestAnswer(
            questionID: questions[currentQuestionIndex].id,
            selectedAnswerIndex: selectedIndex,
            isCorrect: isCorrect
        )
        answers.append(answer)
    }

    mutating func moveToNextQuestion() {
        currentQuestionIndex += 1
    }
}

struct TestAnswer {
    let questionID: String
    let selectedAnswerIndex: Int
    let isCorrect: Bool
}
