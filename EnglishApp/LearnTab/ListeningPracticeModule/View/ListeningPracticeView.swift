//
//  ListeningPracticeView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct ListeningPracticeView: View {
    @EnvironmentObject var learnCoordinator: LearnCoordinator
    @StateObject private var viewModel = ListeningPracticeViewModel()
    @StateObject private var audioPlayer = AudioPlayerManager.shared

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 20) {
                    // Progress indicator
                    progressSection

                    // Audio Player Card
                    AudioPlayerCard(
                        audioPlayer: audioPlayer,
                        onPlayPause: {
                            viewModel.togglePlayPause()
                        },
                        onSeekBackward: {
                            viewModel.seekBackward()
                        },
                        onSeekForward: {
                            viewModel.seekForward()
                        },
                        formatTime: { time in
                            viewModel.formatTime(time)
                        }
                    )
                    .padding(.horizontal)

                    // Up Next section
                    if !viewModel.upcomingAudio.isEmpty {
                        upNextSection
                    }
                }
                .padding(.top)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Listening Practice")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    // Future: Settings
                } label: {
                    Image(systemName: "gearshape.fill")
                        .foregroundStyle(.darkBlue)
                }
            }
        }
        .onDisappear {
            // Pause playback when leaving screen
            audioPlayer.pause()
        }
    }

    private var progressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Progress")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                Spacer()

                Text("\(viewModel.getCompletedCount())/\(viewModel.getTotalCount())")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            // Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.gray.opacity(0.2))
                        .frame(height: 6)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(.blue)
                        .frame(
                            width: geometry.size.width * (Double(viewModel.getCompletedCount()) / Double(viewModel.getTotalCount())),
                            height: 6
                        )
                }
            }
            .frame(height: 6)
        }
        .padding(.horizontal)
    }

    private var upNextSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Up Next")
                .font(.headline)
                .padding(.horizontal)

            VStack(spacing: 8) {
                ForEach(viewModel.upcomingAudio) { audio in
                    Button {
                        if !audio.isLocked {
                            viewModel.selectAudio(audio)
                        }
                    } label: {
                        AudioListItemView(
                            audio: audio,
                            isSelected: viewModel.currentAudio?.id == audio.id
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(audio.isLocked)
                    .opacity(audio.isLocked ? 0.6 : 1.0)
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    NavigationStack {
        ListeningPracticeView()
            .environmentObject(LearnCoordinator())
    }
}
