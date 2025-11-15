//
//  GrammarTopicsView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct GrammarTopicsView: View {
    @EnvironmentObject var learnCoordinator: LearnCoordinator
    @StateObject private var viewModel = GrammarTopicsViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            if viewModel.isLoading {
                ProgressView()
            } else {
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(viewModel.topics) { topic in
                            Button {
                                learnCoordinator.push(.grammarTest(topicID: topic.id))
                            } label: {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(topic.name)
                                            .font(.body)
                                            .foregroundStyle(.primary)

                                        Text("\(topic.questionCount) questions")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }

                                    Spacer()

                                    Image(systemName: "chevron.right")
                                        .foregroundStyle(.secondary)
                                        .font(.caption)
                                }
                                .padding()
                                .background(.white)
                            }
                            .buttonStyle(.plain)

                            if topic.id != viewModel.topics.last?.id {
                                Divider()
                                    .padding(.leading, 16)
                            }
                        }
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding()
                }
            }
        }
        .navigationTitle("Grammar Tests")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        GrammarTopicsView()
            .environmentObject(LearnCoordinator())
    }
}
