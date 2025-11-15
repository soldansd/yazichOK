//
//  ProgressView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct ProgressTabView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()

                VStack {
                    Image(systemName: "trophy.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .foregroundStyle(.darkBlue)
                        .padding()

                    Text("Progress")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 8)

                    Text("Track your learning journey")
                        .foregroundStyle(.secondary)
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
    ProgressTabView()
}
