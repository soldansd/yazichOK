//
//  WordGroupCardView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct WordGroupCardView: View {
    let group: WordGroup
    let cardCount: Int

    var body: some View {
        HStack {
            Image(systemName: "folder.fill")
                .font(.title)
                .foregroundStyle(.darkPurple)
                .frame(width: 50)

            VStack(alignment: .leading, spacing: 4) {
                Text(group.name)
                    .font(.headline)
                    .bold()

                Text("\(cardCount) words")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundStyle(.secondary)
        }
        .padding()
        .background(.pastelPurple.opacity(0.3))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    WordGroupCardView(group: WordGroup(name: "Travel"), cardCount: 15)
        .padding()
}
