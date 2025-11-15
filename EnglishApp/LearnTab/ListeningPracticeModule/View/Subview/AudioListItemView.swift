//
//  AudioListItemView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct AudioListItemView: View {
    let audio: AudioMaterial
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 16) {
            // Volume/Speaker icon
            Image(systemName: "speaker.wave.2.fill")
                .foregroundStyle(isSelected ? .blue : .gray)
                .frame(width: 24)

            // Title and duration
            VStack(alignment: .leading, spacing: 4) {
                Text(audio.title)
                    .font(.body)
                    .foregroundStyle(.primary)

                Text(audio.durationFormatted)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            // Lock icon if locked
            if audio.isLocked {
                Image(systemName: "lock.fill")
                    .foregroundStyle(.gray)
                    .font(.caption)
            }
        }
        .padding()
        .background(isSelected ? .blue.opacity(0.05) : .white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    VStack(spacing: 12) {
        AudioListItemView(
            audio: AudioMaterial.mockAudioMaterials[0],
            isSelected: true
        )

        AudioListItemView(
            audio: AudioMaterial.mockAudioMaterials[1],
            isSelected: false
        )
    }
    .padding()
}
