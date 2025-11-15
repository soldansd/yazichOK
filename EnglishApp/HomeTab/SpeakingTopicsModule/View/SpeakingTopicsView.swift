//
//  SpeakingTopicsView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import SwiftUI
import Lottie

struct SpeakingTopicsView: View {
    
    @StateObject private var topicsVM = TopicsViewModel()
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    private let columns = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()
            
            if topicsVM.topics.isEmpty {
                LottieView(animation: .named("loading"))
                    .playing(loopMode: .loop)
            } else {
                VStack {
                    if let error = topicsVM.errorMessage {
                        Text(error)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: columns, spacing: 16) {
                                ForEach(topicsVM.topics) { topic in
                                    Button {
                                        coordinator.push(.audioRecording(topicID: topic.id))
                                    } label: {
                                        SpeakingTopicCardView(topic: topic)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            
        }
        .task {
            await topicsVM.loadTopics()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Topics")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonToolbar {
                    coordinator.pop()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        SpeakingTopicsView()
    }
}
