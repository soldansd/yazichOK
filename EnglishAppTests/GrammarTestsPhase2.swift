//
//  GrammarTestsPhase2.swift
//  EnglishAppTests
//
//  Created by Claude on 15/11/2025.
//

import XCTest
@testable import EnglishApp

@MainActor
final class GrammarTestsPhase2: XCTestCase {

    // MARK: - GrammarTopic Model Tests

    func testGrammarTopicInitialization() {
        let topic = GrammarTopic(
            id: "test-topic",
            name: "Test Topic",
            description: "Test Description",
            questionCount: 10
        )

        XCTAssertEqual(topic.id, "test-topic")
        XCTAssertEqual(topic.name, "Test Topic")
        XCTAssertEqual(topic.description, "Test Description")
        XCTAssertEqual(topic.questionCount, 10)
    }

    func testGrammarTopicMockData() {
        XCTAssertFalse(GrammarTopic.mockTopics.isEmpty)
        XCTAssertTrue(GrammarTopic.mockTopics.count >= 5)

        let presentSimple = GrammarTopic.mockTopics.first { $0.id == "present-simple" }
        XCTAssertNotNil(presentSimple)
        XCTAssertEqual(presentSimple?.name, "Present Simple")
    }

    func testGrammarTopicHashable() {
        let topic1 = GrammarTopic(id: "1", name: "Topic 1", description: "Desc", questionCount: 5)
        let topic2 = GrammarTopic(id: "1", name: "Topic 1", description: "Desc", questionCount: 5)
        let topic3 = GrammarTopic(id: "2", name: "Topic 2", description: "Desc", questionCount: 5)

        XCTAssertEqual(topic1, topic2)
        XCTAssertNotEqual(topic1, topic3)
    }

    // MARK: - TestQuestion Model Tests

    func testTestQuestionInitialization() {
        let question = TestQuestion(
            id: "q1",
            topicID: "topic1",
            question: "What is the answer?",
            options: ["A", "B", "C", "D"],
            correctAnswerIndex: 2,
            explanation: "Because C is correct"
        )

        XCTAssertEqual(question.id, "q1")
        XCTAssertEqual(question.topicID, "topic1")
        XCTAssertEqual(question.question, "What is the answer?")
        XCTAssertEqual(question.options.count, 4)
        XCTAssertEqual(question.correctAnswerIndex, 2)
        XCTAssertEqual(question.explanation, "Because C is correct")
    }

    func testMockQuestionsForPresentSimple() {
        let questions = TestQuestion.mockQuestions(for: "present-simple")

        XCTAssertFalse(questions.isEmpty)
        XCTAssertTrue(questions.count >= 10)

        for question in questions {
            XCTAssertEqual(question.topicID, "present-simple")
            XCTAssertFalse(question.question.isEmpty)
            XCTAssertFalse(question.options.isEmpty)
            XCTAssertTrue(question.correctAnswerIndex >= 0)
            XCTAssertTrue(question.correctAnswerIndex < question.options.count)
            XCTAssertFalse(question.explanation.isEmpty)
        }
    }

    func testMockQuestionsForDifferentTopics() {
        let presentSimpleQuestions = TestQuestion.mockQuestions(for: "present-simple")
        let pastSimpleQuestions = TestQuestion.mockQuestions(for: "past-simple")

        XCTAssertNotEqual(presentSimpleQuestions.count, 0)
        XCTAssertNotEqual(pastSimpleQuestions.count, 0)

        // Verify questions belong to correct topic
        XCTAssertTrue(presentSimpleQuestions.allSatisfy { $0.topicID == "present-simple" })
        XCTAssertTrue(pastSimpleQuestions.allSatisfy { $0.topicID == "past-simple" })
    }

    func testMockQuestionsForUnknownTopic() {
        let questions = TestQuestion.mockQuestions(for: "unknown-topic")

        XCTAssertFalse(questions.isEmpty)
        XCTAssertTrue(questions.allSatisfy { $0.topicID == "unknown-topic" })
    }

    // MARK: - TestSession Model Tests

    func testTestSessionInitialization() {
        let questions = TestQuestion.mockQuestions(for: "present-simple")
        let session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: questions)

        XCTAssertEqual(session.topicID, "present-simple")
        XCTAssertEqual(session.topicName, "Present Simple")
        XCTAssertEqual(session.currentQuestionIndex, 0)
        XCTAssertTrue(session.answers.isEmpty)
        XCTAssertEqual(session.totalQuestions, questions.count)
        XCTAssertFalse(session.isCompleted)
    }

    func testTestSessionRecordAnswer() {
        let questions = TestQuestion.mockQuestions(for: "present-simple")
        var session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: questions)

        XCTAssertEqual(session.correctAnswersCount, 0)
        XCTAssertEqual(session.incorrectAnswersCount, 0)

        session.recordAnswer(selectedIndex: 0, isCorrect: true)

        XCTAssertEqual(session.answers.count, 1)
        XCTAssertEqual(session.correctAnswersCount, 1)
        XCTAssertEqual(session.incorrectAnswersCount, 0)
    }

    func testTestSessionMoveToNextQuestion() {
        let questions = TestQuestion.mockQuestions(for: "present-simple")
        var session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: questions)

        XCTAssertEqual(session.currentQuestionIndex, 0)

        session.moveToNextQuestion()

        XCTAssertEqual(session.currentQuestionIndex, 1)
    }

    func testTestSessionCompletion() {
        let questions = TestQuestion.mockQuestions(for: "present-simple").prefix(3)
        var session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: Array(questions))

        XCTAssertFalse(session.isCompleted)

        for i in 0..<3 {
            session.recordAnswer(selectedIndex: 0, isCorrect: i % 2 == 0)
            session.moveToNextQuestion()
        }

        XCTAssertTrue(session.isCompleted)
    }

    func testTestSessionScoreCounting() {
        let questions = TestQuestion.mockQuestions(for: "present-simple").prefix(5)
        var session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: Array(questions))

        // Answer 3 correctly, 2 incorrectly
        session.recordAnswer(selectedIndex: 0, isCorrect: true)
        session.recordAnswer(selectedIndex: 1, isCorrect: false)
        session.recordAnswer(selectedIndex: 0, isCorrect: true)
        session.recordAnswer(selectedIndex: 1, isCorrect: false)
        session.recordAnswer(selectedIndex: 0, isCorrect: true)

        XCTAssertEqual(session.correctAnswersCount, 3)
        XCTAssertEqual(session.incorrectAnswersCount, 2)
    }

    // MARK: - GrammarTopicsViewModel Tests

    func testGrammarTopicsViewModelInitialization() {
        let viewModel = GrammarTopicsViewModel()

        XCTAssertFalse(viewModel.isLoading)
        // Topics should be loaded after initialization
        XCTAssertFalse(viewModel.topics.isEmpty)
    }

    func testGrammarTopicsViewModelLoadTopics() async {
        let viewModel = GrammarTopicsViewModel()
        viewModel.topics = []

        viewModel.loadTopics()

        // Wait for async loading
        try? await Task.sleep(nanoseconds: 500_000_000)

        XCTAssertFalse(viewModel.topics.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
    }

    // MARK: - GrammarTestViewModel Tests

    func testGrammarTestViewModelInitialization() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        XCTAssertEqual(viewModel.session.topicID, "present-simple")
        XCTAssertEqual(viewModel.session.topicName, "Present Simple")
        XCTAssertNil(viewModel.selectedAnswerIndex)
        XCTAssertFalse(viewModel.hasCheckedAnswer)
        XCTAssertFalse(viewModel.showingResult)
        XCTAssertNotNil(viewModel.currentQuestion)
    }

    func testGrammarTestViewModelSelectAnswer() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        XCTAssertNil(viewModel.selectedAnswerIndex)

        viewModel.selectAnswer(2)

        XCTAssertEqual(viewModel.selectedAnswerIndex, 2)
    }

    func testGrammarTestViewModelCannotSelectAfterChecking() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        viewModel.selectAnswer(0)
        viewModel.checkAnswer()

        let previousSelection = viewModel.selectedAnswerIndex

        viewModel.selectAnswer(1)

        // Selection should not change after checking
        XCTAssertEqual(viewModel.selectedAnswerIndex, previousSelection)
    }

    func testGrammarTestViewModelCheckAnswer() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        viewModel.selectAnswer(0)

        XCTAssertFalse(viewModel.hasCheckedAnswer)
        XCTAssertFalse(viewModel.showingResult)

        viewModel.checkAnswer()

        XCTAssertTrue(viewModel.hasCheckedAnswer)
        XCTAssertTrue(viewModel.showingResult)
        XCTAssertEqual(viewModel.session.answers.count, 1)
    }

    func testGrammarTestViewModelCanCheckAnswer() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        XCTAssertFalse(viewModel.canCheckAnswer)

        viewModel.selectAnswer(0)

        XCTAssertTrue(viewModel.canCheckAnswer)

        viewModel.checkAnswer()

        XCTAssertFalse(viewModel.canCheckAnswer)
    }

    func testGrammarTestViewModelIsAnswerCorrect() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        guard let currentQuestion = viewModel.currentQuestion else {
            XCTFail("No current question")
            return
        }

        // Select correct answer
        viewModel.selectAnswer(currentQuestion.correctAnswerIndex)
        XCTAssertTrue(viewModel.isAnswerCorrect)

        // Reset for next test
        viewModel.continueToNextQuestion()

        guard let nextQuestion = viewModel.currentQuestion else {
            XCTFail("No next question")
            return
        }

        // Select incorrect answer
        let incorrectIndex = (nextQuestion.correctAnswerIndex + 1) % nextQuestion.options.count
        viewModel.selectAnswer(incorrectIndex)
        XCTAssertFalse(viewModel.isAnswerCorrect)
    }

    func testGrammarTestViewModelContinueToNextQuestion() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        let firstQuestionIndex = viewModel.session.currentQuestionIndex

        viewModel.selectAnswer(0)
        viewModel.checkAnswer()
        viewModel.continueToNextQuestion()

        XCTAssertEqual(viewModel.session.currentQuestionIndex, firstQuestionIndex + 1)
        XCTAssertNil(viewModel.selectedAnswerIndex)
        XCTAssertFalse(viewModel.hasCheckedAnswer)
        XCTAssertFalse(viewModel.showingResult)
    }

    func testGrammarTestViewModelProgressPercentage() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        let totalQuestions = viewModel.session.totalQuestions
        let initialProgress = viewModel.getProgressPercentage()

        XCTAssertEqual(initialProgress, 1.0 / Double(totalQuestions), accuracy: 0.01)

        viewModel.selectAnswer(0)
        viewModel.checkAnswer()
        viewModel.continueToNextQuestion()

        let secondProgress = viewModel.getProgressPercentage()
        XCTAssertEqual(secondProgress, 2.0 / Double(totalQuestions), accuracy: 0.01)
    }

    func testGrammarTestViewModelFullTestFlow() {
        let viewModel = GrammarTestViewModel(topicID: "present-simple", topicName: "Present Simple")

        let totalQuestions = min(viewModel.session.totalQuestions, 3) // Test first 3 questions

        for _ in 0..<totalQuestions {
            XCTAssertNotNil(viewModel.currentQuestion)

            viewModel.selectAnswer(0)
            XCTAssertTrue(viewModel.canCheckAnswer)

            viewModel.checkAnswer()
            XCTAssertTrue(viewModel.hasCheckedAnswer)
            XCTAssertTrue(viewModel.showingResult)

            viewModel.continueToNextQuestion()
        }

        XCTAssertEqual(viewModel.session.answers.count, totalQuestions)
    }

    // MARK: - Integration Tests

    func testCompleteTestSessionFlow() {
        let questions = TestQuestion.mockQuestions(for: "present-simple").prefix(5)
        var session = TestSession(topicID: "present-simple", topicName: "Present Simple", questions: Array(questions))

        XCTAssertFalse(session.isCompleted)

        for i in 0..<5 {
            XCTAssertEqual(session.currentQuestionIndex, i)

            let currentQuestion = session.questions[i]
            let isCorrect = i % 2 == 0 // Alternate correct/incorrect

            session.recordAnswer(selectedIndex: isCorrect ? currentQuestion.correctAnswerIndex : 0, isCorrect: isCorrect)
            session.moveToNextQuestion()
        }

        XCTAssertTrue(session.isCompleted)
        XCTAssertEqual(session.correctAnswersCount, 3)
        XCTAssertEqual(session.incorrectAnswersCount, 2)
    }

    func testTopicHasCorrespondingQuestions() {
        for topic in GrammarTopic.mockTopics {
            let questions = TestQuestion.mockQuestions(for: topic.id)

            XCTAssertFalse(questions.isEmpty, "Topic \(topic.name) should have questions")
            XCTAssertTrue(questions.allSatisfy { $0.topicID == topic.id }, "All questions should belong to topic \(topic.id)")
        }
    }
}
