//
//  TestResultCard.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct TestResultCard: View {
    let isCorrect: Bool
    let explanation: String
    let onContinue: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Result header
            HStack(spacing: 12) {
                Image(systemName: isCorrect ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .font(.title2)
                    .foregroundStyle(isCorrect ? .green : .red)

                Text(isCorrect ? "Correct!" : "Incorrect")
                    .font(.headline)
                    .foregroundStyle(isCorrect ? .green : .red)

                Spacer()
            }

            // Explanation
            Text(explanation)
                .font(.body)
                .foregroundStyle(isCorrect ? Color(red: 0.0, green: 0.5, blue: 0.4) : .red.opacity(0.8))
                .fixedSize(horizontal: false, vertical: true)

            // Continue button
            Button {
                onContinue()
            } label: {
                Text("Continue")
                    .font(.headline)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isCorrect ? Color(red: 0.0, green: 0.6, blue: 0.5) : .red)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding()
        .background(isCorrect ? Color(red: 0.85, green: 0.98, blue: 0.95) : .red.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
    }
}

#Preview {
    VStack(spacing: 20) {
        TestResultCard(
            isCorrect: true,
            explanation: "The third person singular (he/she/it) in Present Simple takes -s or -es at the end of the verb.",
            onContinue: {}
        )

        TestResultCard(
            isCorrect: false,
            explanation: "Remember: third person singular requires the -s ending in Present Simple.",
            onContinue: {}
        )
    }
    .padding()
}
