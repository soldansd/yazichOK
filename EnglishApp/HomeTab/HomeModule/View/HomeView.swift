//
//  HomeView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import SwiftUI

struct HomeView: View {

    @StateObject private var homeCoordinator = HomeCoordinator()
    @StateObject private var homeVM = HomeViewModel()
    @StateObject private var flashCardStorage = FlashCardStorage.shared
    
    var body: some View {
        NavigationStack(path: $homeCoordinator.path) {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()
                
                VStack {
                    speachAssesment

                    flashcardsSection

                    if !homeVM.articles.isEmpty {
                        HStack {
                            Text("Recommended Articles")
                            Spacer()
                            Button {
                                homeCoordinator.push(.articlesPreview)
                            } label: {
                                Text("See all")
                                    .foregroundStyle(.darkBlue)
                                    .bold()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                        
                        ScrollView {
                            ForEach(homeVM.articles.prefix(3)) { article in
                                Button {
                                    homeCoordinator.push(.article(id: article.id))
                                } label: {
                                    ArticlePreviewCardView(article: article)
                                        .padding(.horizontal, 8)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .task {
                    await homeVM.loadArticles()
                }
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                    
                case .topicsList:
                    SpeakingTopicsView()
                        .environmentObject(homeCoordinator)
                    
                case .audioRecording(let topicId):
                    RecordingView(
                        recordingVM: RecordingViewModel(
                            topicId: topicId
                        )
                    )
                    .environmentObject(homeCoordinator)
                    
                case .assesmentResults(let sessionId):
                    SpeakingAssesmentView(
                        assesmentVM: SpeakingAssessmentViewModel(
                            sessionID: sessionId
                        )
                    )
                    .environmentObject(homeCoordinator)
                    
                case .articlesPreview:
                    ArticlesPreviewView()
                        .environmentObject(homeCoordinator)
                    
                case .article(let id):
                    ArticleView(articleVM: ArticleViewModel(articleID: id))
                        .environmentObject(homeCoordinator)
                    
                case .articleAnalisis(let article):
                    ArticleAnalysisView(article: article)
                        .environmentObject(homeCoordinator)

                case .flashCards:
                    FlashCardsMainView()
                        .environmentObject(homeCoordinator)

                case .addNewWord:
                    AddNewWordView()
                        .environmentObject(homeCoordinator)

                case .addNewWordsGroup:
                    AddNewWordsGroupView()
                        .environmentObject(homeCoordinator)

                case .memoriseWords(let groupID):
                    MemoriseWordsView(groupID: groupID)
                        .environmentObject(homeCoordinator)
                }
            }
        }
    }
    
    private var speachAssesment: some View {
        VStack(spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text("Speech Practice")
                        .font(.headline)
                        .bold()
                    
                    Text ("Practice your speaking skills")
                        .font(.footnote)
                }
                
                Spacer()
                
                Image(systemName: "microphone.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.darkBlue)
            }
            
            Button {
                homeCoordinator.push(.topicsList)
            } label: {
                Text("Start speaking")
                    .foregroundStyle(.appForeground)
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(.darkBlue)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
        }
        .padding()
        .background(.pastelBlue)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .padding(8)
    }

    private var flashcardsSection: some View {
        Button {
            homeCoordinator.push(.flashCards)
        } label: {
            VStack(spacing: 16) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Flashcards")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.primary)

                        Text("Review your vocabulary")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Spacer()

                    Image(systemName: "gearshape.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.darkPurple)
                }

                HStack(spacing: 8) {
                    Text("\(flashCardStorage.getNewCardsCount()) new")
                        .font(.footnote)
                        .foregroundStyle(.darkPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.pastelPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Text("\(flashCardStorage.getReviewCardsCount()) to review")
                        .font(.footnote)
                        .foregroundStyle(.darkPurple)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(.pastelPurple)
                        .clipShape(RoundedRectangle(cornerRadius: 12))

                    Spacer()
                }
            }
            .padding()
            .background(.pastelPurple.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .padding(8)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
