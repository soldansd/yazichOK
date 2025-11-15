//
//  GrammarTestView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct GrammarTestView: View {
    @EnvironmentObject var learnCoordinator: LearnCoordinator
    @StateObject private var viewModel: GrammarTestViewModel
    @State private var showingSummary = false

    init(topicID: String, topicName: String) {
        _viewModel = StateObject(wrappedValue: GrammarTestViewModel(topicID: topicID, topicName: topicName))
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            if showingSummary {
                TestSummaryView(
                    topicName: viewModel.session.topicName,
                    correctAnswers: viewModel.session.correctAnswersCount,
                    incorrectAnswers: viewModel.session.incorrectAnswersCount,
                    totalQuestions: viewModel.session.totalQuestions,
                    onClose: {
                        learnCoordinator.pop()
                    }
                )
            } else {
                VStack(spacing: 0) {
                    // Progress bar
                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .frame(height: 6)

                            Rectangle()
                                .fill(.green)
                                .frame(width: geometry.size.width * viewModel.getProgressPercentage(), height: 6)
                        }
                    }
                    .frame(height: 6)

                    ScrollView {
                        VStack(spacing: 20) {
                            if let currentQuestion = viewModel.currentQuestion {
                                // Question card
                                TestQuestionCard(
                                    question: currentQuestion,
                                    questionNumber: viewModel.session.currentQuestionIndex + 1,
                                    totalQuestions: viewModel.session.totalQuestions,
                                    selectedAnswerIndex: viewModel.selectedAnswerIndex,
                                    hasCheckedAnswer: viewModel.hasCheckedAnswer,
                                    isAnswerCorrect: viewModel.isAnswerCorrect,
                                    onSelectAnswer: { index in
                                        viewModel.selectAnswer(index)
                                    }
                                )

                                // Check button
                                if !viewModel.hasCheckedAnswer {
                                    Button {
                                        viewModel.checkAnswer()
                                    } label: {
                                        Text("Check")
                                            .font(.headline)
                                            .foregroundStyle(.white)
                                            .frame(maxWidth: .infinity)
                                            .padding()
                                            .background(viewModel.canCheckAnswer ? .darkBlue : .gray)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    }
                                    .disabled(!viewModel.canCheckAnswer)
                                    .padding(.horizontal)
                                }

                                // Result card
                                if viewModel.showingResult {
                                    TestResultCard(
                                        isCorrect: viewModel.isAnswerCorrect,
                                        explanation: currentQuestion.explanation,
                                        onContinue: {
                                            viewModel.continueToNextQuestion()

                                            if viewModel.session.isCompleted {
                                                showingSummary = true
                                            }
                                        }
                                    )
                                    .padding(.horizontal)
                                    .transition(.move(edge: .bottom).combined(with: .opacity))
                                }
                            }
                        }
                        .padding(.top)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .navigationTitle(viewModel.session.topicName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                HStack(spacing: 8) {
                    Text("\(viewModel.session.correctAnswersCount)/\(viewModel.session.totalQuestions)")
                        .font(.headline)
                        .foregroundStyle(.green)

                    Image(systemName: "trophy.fill")
                        .foregroundStyle(.green)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        GrammarTestView(topicID: "present-simple", topicName: "Present Simple")
            .environmentObject(LearnCoordinator())
    }
}
