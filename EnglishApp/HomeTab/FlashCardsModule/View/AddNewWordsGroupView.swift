//
//  AddNewWordsGroupView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct AddNewWordsGroupView: View {
    @EnvironmentObject var coordinator: HomeCoordinator
    @State private var groupName = ""
    @FocusState private var isTextFieldFocused: Bool

    private let storage = FlashCardStorage.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Group Name")
                        .font(.headline)
                        .foregroundStyle(.primary)

                    TextField("Enter group name", text: $groupName)
                        .textFieldStyle(.roundedBorder)
                        .focused($isTextFieldFocused)
                }
                .padding()

                Button {
                    saveGroup()
                } label: {
                    Text("Save")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(groupName.isEmpty ? Color.gray : Color.darkPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .disabled(groupName.isEmpty)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("New Group")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonToolbar()
            }
        }
        .onAppear {
            isTextFieldFocused = true
        }
    }

    private func saveGroup() {
        guard !groupName.isEmpty else { return }

        let newGroup = WordGroup(name: groupName.trimmingCharacters(in: .whitespacesAndNewlines))
        Task {
            await storage.addGroup(newGroup)
            await MainActor.run {
                coordinator.pop()
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddNewWordsGroupView()
            .environmentObject(HomeCoordinator())
    }
}
