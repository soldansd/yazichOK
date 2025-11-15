//
//  TestSummaryView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct TestSummaryView: View {
    let topicName: String
    let correctAnswers: Int
    let incorrectAnswers: Int
    let totalQuestions: Int
    let onClose: () -> Void

    private var scorePercentage: Int {
        guard totalQuestions > 0 else { return 0 }
        return Int((Double(correctAnswers) / Double(totalQuestions)) * 100)
    }

    private var resultMessage: String {
        switch scorePercentage {
        case 90...100:
            return "Excellent work!"
        case 70..<90:
            return "Great job!"
        case 50..<70:
            return "Good effort!"
        default:
            return "Keep practicing!"
        }
    }

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Trophy icon
            Image(systemName: scorePercentage >= 70 ? "trophy.fill" : "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(scorePercentage >= 70 ? .yellow : .green)
                .padding()

            // Result message
            Text(resultMessage)
                .font(.title)
                .bold()

            // Topic name
            Text(topicName)
                .font(.headline)
                .foregroundStyle(.secondary)

            // Statistics card
            VStack(spacing: 16) {
                // Score percentage
                Text("\(scorePercentage)%")
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(.darkBlue)

                Divider()

                // Correct answers
                HStack {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                    Text("Correct answers:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(correctAnswers)")
                        .bold()
                        .foregroundStyle(.green)
                }

                // Incorrect answers
                HStack {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.red)
                    Text("Incorrect answers:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(incorrectAnswers)")
                        .bold()
                        .foregroundStyle(.red)
                }

                Divider()

                // Total questions
                HStack {
                    Text("Total questions:")
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(totalQuestions)")
                        .bold()
                }
            }
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
            .padding(.horizontal)

            Spacer()

            // Close button
            Button {
                onClose()
            } label: {
                Text("Done")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.darkBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    ZStack {
        Rectangle()
            .fill(.appBackground)
            .ignoresSafeArea()

        TestSummaryView(
            topicName: "Present Simple",
            correctAnswers: 16,
            incorrectAnswers: 4,
            totalQuestions: 20,
            onClose: {}
        )
    }
}
