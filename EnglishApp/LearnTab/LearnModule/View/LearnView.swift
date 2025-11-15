//
//  LearnView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct LearnView: View {
    @StateObject private var learnCoordinator = LearnCoordinator()

    var body: some View {
        NavigationStack(path: $learnCoordinator.path) {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()

                VStack {
                    Text("Learn")
                        .font(.largeTitle)
                        .bold()
                        .padding()

                    Text("Coming soon: Grammar Tests and Listening Practice")
                        .foregroundStyle(.secondary)
                        .padding()

                    Spacer()
                }
            }
            .navigationDestination(for: LearnScreen.self) { screen in
                switch screen {
                case .grammarTopics:
                    Text("Grammar Topics")
                        .environmentObject(learnCoordinator)

                case .grammarTest(let topicID):
                    Text("Grammar Test: \(topicID)")
                        .environmentObject(learnCoordinator)

                case .listeningPractice:
                    Text("Listening Practice")
                        .environmentObject(learnCoordinator)
                }
            }
        }
    }
}

#Preview {
    LearnView()
}
