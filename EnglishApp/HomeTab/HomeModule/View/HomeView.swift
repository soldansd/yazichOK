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
    
    var body: some View {
        NavigationStack(path: $homeCoordinator.path) {
            ZStack {
                Rectangle()
                    .fill(.appBackground)
                    .ignoresSafeArea()
                
                VStack {
                    speachAssesment
                    
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
}

#Preview {
    NavigationStack {
        HomeView()
    }
}
