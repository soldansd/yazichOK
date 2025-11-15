//
//  AudioPlayerCard.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct AudioPlayerCard: View {
    @ObservedObject var audioPlayer: AudioPlayerManager
    let onPlayPause: () -> Void
    let onSeekBackward: () -> Void
    let onSeekForward: () -> Void
    let formatTime: (TimeInterval) -> String

    var body: some View {
        VStack(spacing: 20) {
            // Now Playing label
            Text("Now Playing")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            // Audio title
            if let currentAudio = audioPlayer.currentAudio {
                Text(currentAudio.title)
                    .font(.title3)
                    .bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            // Circular audio indicator / waveform placeholder
            ZStack {
                Circle()
                    .fill(.gray.opacity(0.1))
                    .frame(width: 120, height: 120)

                if audioPlayer.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                } else {
                    Image(systemName: audioPlayer.isPlaying ? "waveform.circle.fill" : "waveform.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .foregroundStyle(.blue)
                }
            }
            .padding(.vertical, 8)

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 6)

                    // Progress
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.blue)
                        .frame(
                            width: audioPlayer.duration > 0 ?
                                geometry.size.width * (audioPlayer.currentTime / audioPlayer.duration) : 0,
                            height: 6
                        )
                }
            }
            .frame(height: 6)

            // Time labels
            HStack {
                Text(formatTime(audioPlayer.currentTime))
                    .font(.caption)
                    .foregroundStyle(.secondary)

                Spacer()

                Text(formatTime(audioPlayer.duration))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            // Playback controls
            HStack(spacing: 40) {
                // Skip backward button
                Button {
                    onSeekBackward()
                } label: {
                    Image(systemName: "backward.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .disabled(audioPlayer.currentAudio == nil)

                // Play/Pause button
                Button {
                    onPlayPause()
                } label: {
                    ZStack {
                        Circle()
                            .fill(.blue)
                            .frame(width: 64, height: 64)

                        Image(systemName: audioPlayer.isPlaying ? "pause.fill" : "play.fill")
                            .font(.title)
                            .foregroundStyle(.white)
                            .offset(x: audioPlayer.isPlaying ? 0 : 2) // Center play icon visually
                    }
                }
                .disabled(audioPlayer.currentAudio == nil)

                // Skip forward button
                Button {
                    onSeekForward()
                } label: {
                    Image(systemName: "forward.fill")
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .disabled(audioPlayer.currentAudio == nil)
            }
        }
        .padding()
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    AudioPlayerCard(
        audioPlayer: AudioPlayerManager.shared,
        onPlayPause: {},
        onSeekBackward: {},
        onSeekForward: {},
        formatTime: { time in
            let minutes = Int(time) / 60
            let seconds = Int(time) % 60
            return String(format: "%d:%02d", minutes, seconds)
        }
    )
    .padding()
    .background(.gray.opacity(0.1))
}
