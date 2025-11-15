//
//  ProfileView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundStyle(.darkBlue)
                        .padding()

                    Text("Profile")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 8)

                    Text("Manage your account and settings")
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.bottom, 32)

                    Text("Coming soon")
                        .font(.headline)
                        .foregroundStyle(.darkBlue)
                        .padding()
                        .background(.pastelBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 8))

                    Spacer()
                }
                .padding()
            }
        }
    }
}

#Preview {
    ProfileView()
}
