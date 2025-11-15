//
//  TestQuestionCard.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct TestQuestionCard: View {
    let question: TestQuestion
    let questionNumber: Int
    let totalQuestions: Int
    let selectedAnswerIndex: Int?
    let hasCheckedAnswer: Bool
    let isAnswerCorrect: Bool
    let onSelectAnswer: (Int) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Question number
            Text("Question \(questionNumber) of \(totalQuestions)")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            // Question text
            Text(question.question)
                .font(.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)

            // Answer options
            VStack(spacing: 12) {
                ForEach(Array(question.options.enumerated()), id: \.offset) { index, option in
                    answerButton(text: option, index: index)
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private func answerButton(text: String, index: Int) -> some View {
        Button {
            onSelectAnswer(index)
        } label: {
            HStack {
                Text(text)
                    .font(.body)
                    .foregroundStyle(textColor(for: index))
                    .multilineTextAlignment(.leading)

                Spacer()

                if hasCheckedAnswer && index == selectedAnswerIndex {
                    Image(systemName: isAnswerCorrect ? "checkmark" : "xmark")
                        .foregroundStyle(isAnswerCorrect ? .green : .red)
                }
            }
            .padding()
            .background(backgroundColor(for: index))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(borderColor(for: index), lineWidth: isSelected(index) ? 2 : 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(hasCheckedAnswer)
    }

    private func isSelected(_ index: Int) -> Bool {
        selectedAnswerIndex == index
    }

    private func backgroundColor(for index: Int) -> Color {
        if hasCheckedAnswer && isSelected(index) {
            return isAnswerCorrect ? .green.opacity(0.1) : .red.opacity(0.1)
        }
        return isSelected(index) ? .green.opacity(0.05) : .white
    }

    private func borderColor(for index: Int) -> Color {
        if hasCheckedAnswer && isSelected(index) {
            return isAnswerCorrect ? .green : .red
        }
        return isSelected(index) ? .green : .gray.opacity(0.3)
    }

    private func textColor(for index: Int) -> Color {
        if hasCheckedAnswer && !isSelected(index) {
            return .gray
        }
        return .primary
    }
}

#Preview {
    TestQuestionCard(
        question: TestQuestion.mockQuestions(for: "present-simple")[0],
        questionNumber: 12,
        totalQuestions: 20,
        selectedAnswerIndex: 0,
        hasCheckedAnswer: false,
        isAnswerCorrect: true,
        onSelectAnswer: { _ in }
    )
    .padding()
}
