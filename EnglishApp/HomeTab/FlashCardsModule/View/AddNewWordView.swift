//
//  AddNewWordView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct AddNewWordView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    @StateObject private var viewModel = AddWordViewModel()

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Word field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Word")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Enter new word", text: $viewModel.word)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Translation field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Translation")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Enter translation", text: $viewModel.translation)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Example sentence field
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Example sentence")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        TextField("Write an example sentence", text: $viewModel.exampleSentence, axis: .vertical)
                            .textFieldStyle(.roundedBorder)
                            .lineLimit(3...6)
                    }

                    // Pronunciation section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "speaker.wave.2.fill")
                                .foregroundStyle(.darkPurple)
                            Text("Pronunciation")
                                .font(.subheadline)
                            Spacer()
                        }

                        TextField("Enter pronunciation (e.g., [ədˈventʃər])", text: $viewModel.pronunciation)
                            .textFieldStyle(.roundedBorder)
                    }

                    // Category (Group) selector
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundStyle(.darkPurple)
                            Text("Category")
                                .font(.subheadline)
                            Spacer()
                        }

                        Menu {
                            ForEach(viewModel.groups) { group in
                                Button {
                                    viewModel.selectedGroup = group
                                } label: {
                                    HStack {
                                        Text(group.name)
                                        if viewModel.selectedGroup?.id == group.id {
                                            Image(systemName: "checkmark")
                                        }
                                    }
                                }
                            }
                        } label: {
                            HStack {
                                Text(viewModel.selectedGroup?.name ?? "Select category")
                                    .foregroundStyle(viewModel.selectedGroup == nil ? .secondary : .primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundStyle(.secondary)
                            }
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }

                    // Difficulty level
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Difficulty level")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        HStack(spacing: 12) {
                            ForEach(DifficultyLevel.allCases, id: \.self) { level in
                                Button {
                                    viewModel.selectedDifficulty = level
                                } label: {
                                    Text(level.rawValue)
                                        .font(.subheadline)
                                        .foregroundStyle(viewModel.selectedDifficulty == level ? .white : .primary)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 12)
                                        .frame(maxWidth: .infinity)
                                        .background(difficultyColor(for: level))
                                        .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                            }
                        }
                    }

                    // Add button
                    Button {
                        saveWord()
                    } label: {
                        Text("Add to My Words")
                            .foregroundStyle(.white)
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(viewModel.isValid ? Color.darkBlue : Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .disabled(!viewModel.isValid)
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("New Word")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Save") {
                    saveWord()
                }
                .foregroundStyle(.darkBlue)
                .disabled(!viewModel.isValid)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonToolbar()
            }
        }
    }

    private func difficultyColor(for level: DifficultyLevel) -> Color {
        if viewModel.selectedDifficulty == level {
            switch level {
            case .easy: return .pastelGreen
            case .medium: return .pastelOrange
            case .hard: return .pastelRed
            }
        } else {
            return .gray.opacity(0.2)
        }
    }

    private func saveWord() {
        guard viewModel.isValid else { return }
        Task {
            await viewModel.saveCard()
            coordinator.pop()
        }
    }
}

#Preview {
    NavigationStack {
        AddNewWordView()
            .environmentObject(HomeCoordinator())
    }
}
