//
//  ProfileView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var authManager = MockAuthManager.shared

    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.darkBlue)
                        .padding()

                    if let user = authManager.currentUser {
                        VStack(spacing: 8) {
                            Text(user.fullName)
                                .font(.title2)
                                .bold()

                            Text(user.email)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text("Manage your account and settings")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 16)

                    // Settings sections
                    VStack(spacing: 0) {
                        settingRow(icon: "person.fill", title: "Account Settings")
                        Divider().padding(.leading, 60)
                        settingRow(icon: "bell.fill", title: "Notifications")
                        Divider().padding(.leading, 60)
                        settingRow(icon: "lock.fill", title: "Privacy")
                        Divider().padding(.leading, 60)
                        settingRow(icon: "questionmark.circle.fill", title: "Help & Support")
                    }
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal)

                    // Sign Out button
                    Button {
                        authManager.signOut()
                    } label: {
                        Text("Sign Out")
                            .font(.headline)
                            .foregroundStyle(.red)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 32)
            }
        }
    }

    private func settingRow(icon: String, title: String) -> some View {
        HStack {
            Image(systemName: icon)
                .foregroundStyle(.darkBlue)
                .frame(width: 24)
                .padding(.leading)

            Text(title)
                .foregroundStyle(.primary)
                .padding(.vertical, 16)

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
                .font(.caption)
                .padding(.trailing)
        }
    }
}

#Preview {
    ProfileView()
}
