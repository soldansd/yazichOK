//
//  MemoriseWordsView.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

struct MemoriseWordsView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var coordinator: HomeCoordinator
    @StateObject private var viewModel: MemoriseViewModel
    @State private var cardRotation: Double = 0
    @State private var textOpacity: Double = 1.0

    init(groupID: UUID) {
        _viewModel = StateObject(wrappedValue: MemoriseViewModel(groupID: groupID))
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()

            if viewModel.showingStatistics {
                statisticsView
            } else {
                reviewContent
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("Words Review")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                BackButtonToolbar()
            }
        }
        .task {
            await viewModel.startSession()
        }
    }

    private var reviewContent: some View {
        VStack(spacing: 0) {
            // Progress bar
            if let session = viewModel.session {
                VStack(spacing: 8) {
                    HStack {
                        Text("\(session.remainingCards) words left")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Spacer()
                    }
                    .padding(.horizontal)

                    GeometryReader { geometry in
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .fill(.gray.opacity(0.2))
                                .frame(height: 4)

                            Rectangle()
                                .fill(.darkBlue)
                                .frame(width: progressWidth(total: geometry.size.width), height: 4)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal)
                }
                .padding(.vertical, 12)
            }

            Spacer()

            // Flash card
            if let currentCard = viewModel.session?.currentCard {
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(radius: 8)
                    .frame(height: 400)
                    .padding(.horizontal, 24)
                    .rotation3DEffect(
                        .degrees(cardRotation),
                        axis: (x: 0, y: 1, z: 0)
                    )
                    .overlay {
                        flashCardView(for: currentCard)
                    }
                    .onTapGesture {
                        // Hide text first
                        withAnimation(.easeOut(duration: 0.2)) {
                            textOpacity = 0
                        }

                        // Rotate card and flip data after text fades out
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                viewModel.flipCard()
                                cardRotation = cardRotation == 0 ? 180 : 0
                            }

                            // Show text after rotation starts
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                withAnimation(.easeIn(duration: 0.2)) {
                                    textOpacity = 1
                                }
                            }
                        }
                    }
            }

            Spacer()

            // Action buttons
            HStack(spacing: 16) {
                Button {
                    withAnimation {
                        viewModel.markAsUnknown()
                        cardRotation = 0
                        textOpacity = 1.0
                    }
                } label: {
                    HStack {
                        Image(systemName: "xmark")
                        Text("Don't know")
                    }
                    .foregroundStyle(.darkRed)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.pastelRed.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    withAnimation {
                        viewModel.markAsKnown()
                        cardRotation = 0
                        textOpacity = 1.0
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark")
                        Text("Know")
                    }
                    .foregroundStyle(.darkGreen)
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.pastelGreen.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 16)

            // Statistics bar
            if let session = viewModel.session {
                HStack(spacing: 32) {
                    HStack(spacing: 8) {
                        Image(systemName: "clock.fill")
                            .foregroundStyle(.darkBlue)
                        Text("Time: \(viewModel.formattedTime)")
                            .font(.caption)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.darkGreen)
                        Text("Correct: \(session.correctCount)")
                            .font(.caption)
                    }

                    HStack(spacing: 8) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.darkRed)
                        Text("Wrong: \(session.wrongCount)")
                            .font(.caption)
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(radius: 2)
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
        }
    }

    private func flashCardView(for card: FlashCard) -> some View {
        VStack(spacing: 20) {
            Spacer()

            if viewModel.session?.showingTranslation == false {
                // Front side
                VStack(spacing: 12) {
                    Text(card.word)
                        .font(.system(size: 42, weight: .bold))
                        .multilineTextAlignment(.center)

                    if !card.pronunciation.isEmpty {
                        Text(card.pronunciation)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    }
                }
                .opacity(textOpacity)

                Spacer()

                HStack(spacing: 8) {
                    Image(systemName: "arrow.triangle.2.circlepath")
                        .foregroundStyle(.darkBlue)
                    Text("Tap to flip")
                        .foregroundStyle(.darkBlue)
                }
                .font(.subheadline)
                .padding(.bottom)
                .opacity(textOpacity)
            } else {
                // Back side
                VStack(spacing: 16) {
                    Text(card.translation)
                        .font(.system(size: 36, weight: .semibold))
                        .multilineTextAlignment(.center)

                    if !card.exampleSentence.isEmpty {
                        Text(card.exampleSentence)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                }
                .opacity(textOpacity)

                Spacer()
            }
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 24)
    }

    private var statisticsView: some View {
        VStack(spacing: 24) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 60))
                .foregroundStyle(.darkGreen)

            Text("Session Complete!")
                .font(.title)
                .bold()

            if let session = viewModel.session {
                VStack(spacing: 16) {
                    HStack(spacing: 40) {
                        VStack {
                            Text("\(session.correctCount)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.darkGreen)
                            Text("Correct")
                                .foregroundStyle(.secondary)
                        }

                        VStack {
                            Text("\(session.wrongCount)")
                                .font(.system(size: 36, weight: .bold))
                                .foregroundStyle(.darkRed)
                            Text("Wrong")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .shadow(radius: 4)

                    Text("Time: \(viewModel.formattedTime)")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }

            VStack(spacing: 12) {
                Button {
                    Task {
                        await viewModel.restartSession()
                    }
                } label: {
                    Text("Review Again")
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.darkBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Button {
                    coordinator.popToRoot()
                } label: {
                    Text("Back to Home")
                        .foregroundStyle(.darkBlue)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.pastelBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(.horizontal)
        }
        .padding()
    }

    private func progressWidth(total: CGFloat) -> CGFloat {
        guard let session = viewModel.session else { return 0 }
        let progress = 1.0 - (Double(session.remainingCards) / Double(session.cards.count))
        return total * progress
    }
}

#Preview {
    NavigationStack {
        MemoriseWordsView(groupID: UUID())
            .environmentObject(HomeCoordinator())
    }
}
