//
//  FlashCardsMainView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct FlashCardsMainView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    @StateObject private var viewModel = FlashCardsViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            VStack {
                if viewModel.groups.isEmpty {
                    emptyState
                } else {
                    groupsList
                }
            }

            // Floating action button for adding groups
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        coordinator.push(.addNewWordsGroup)
                    } label: {
                        Image(systemName: "folder.badge.plus")
                            .font(.title2)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.darkPurple)
                            .clipShape(Circle())
                            .shadow(radius: 4)
                    }
                    .padding()
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Flashcards")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    coordinator.push(.addNewWord)
                } label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.darkPurple)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonToolbar()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadGroups()
            }
        }
    }

    private var groupsList: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(viewModel.groups) { group in
                    WordGroupCardView(group: group, cardCount: viewModel.cardCounts[group.id] ?? 0)
                        .onTapGesture {
                            coordinator.push(.memoriseWords(groupID: group.id))
                        }
                        .contextMenu {
                            Button(role: .destructive) {
                                Task {
                                    await viewModel.deleteGroup(group)
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .padding()
            .padding(.bottom, 80) // Space for floating button
        }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 60))
                .foregroundStyle(.darkPurple)

            Text("No word groups yet")
                .font(.title2)
                .bold()

            Text("Create a group to start adding flashcards")
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                coordinator.push(.addNewWordsGroup)
            } label: {
                Text("Create First Group")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.darkPurple)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

#Preview {
    NavigationStack {
        FlashCardsMainView()
            .environmentObject(HomeCoordinator())
    }
}
