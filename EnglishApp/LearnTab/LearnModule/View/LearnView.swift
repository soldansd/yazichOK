//
//  LearnView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct LearnView: View {
    @StateObject private var learnCoordinator = LearnCoordinator()
    @StateObject private var authManager = MockAuthManager.shared

    var body: some View {
        NavigationStack(path: $learnCoordinator.path) {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    // Header
                    HStack {
                        // Profile image
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 44, height: 44)
                            .foregroundStyle(.darkBlue)

                        VStack(alignment: .leading, spacing: 2) {
                            if let user = authManager.currentUser {
                                Text("Hello, \(user.fullName.components(separatedBy: " ").first ?? user.fullName)!")
                                    .font(.body)
                                    .bold()
                            } else {
                                Text("Hello!")
                                    .font(.body)
                                    .bold()
                            }

                            Text("Intermediate Level")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        // Notification bell
                        Button {
                            // Future: Handle notifications
                        } label: {
                            Image(systemName: "bell.fill")
                                .foregroundStyle(.darkBlue)
                        }
                    }
                    .padding()

                    // Learning options list
                    VStack(spacing: 0) {
                        // Listening Practice
                        learnOptionRow(
                            title: "Listening Practice",
                            action: {
                                learnCoordinator.push(.listeningPractice)
                            }
                        )

                        Divider()
                            .padding(.leading, 16)

                        // Tests
                        learnOptionRow(
                            title: "Tests",
                            action: {
                                learnCoordinator.push(.grammarTopics)
                            }
                        )

                        Divider()
                            .padding(.leading, 16)

                        // AI Chat Assistance
                        learnOptionRow(
                            title: "AI Chat Assistance",
                            action: {
                                // Future: Navigate to AI chat
                            }
                        )
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 0))

                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: LearnScreen.self) { screen in
                switch screen {
                case .grammarTopics:
                    GrammarTopicsView()
                        .environmentObject(learnCoordinator)

                case .grammarTest(let topicID):
                    if let topic = GrammarTopic.mockTopics.first(where: { $0.id == topicID }) {
                        GrammarTestView(topicID: topicID, topicName: topic.name)
                            .environmentObject(learnCoordinator)
                    }

                case .listeningPractice:
                    Text("Listening Practice - Coming Soon")
                        .environmentObject(learnCoordinator)
                }
            }
        }
    }

    @ViewBuilder
    private func learnOptionRow(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
            .padding()
            .background(.white)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    LearnView()
}
