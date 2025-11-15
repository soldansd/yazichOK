//
//  ArticlesPreviewView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI

struct ArticlesPreviewView: View {
    
    @StateObject private var articlesVM = ArticlePreviewViewModel()
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()
            
            ScrollView {
                ForEach(articlesVM.articles) { article in
                    Button {
                        coordinator.push(.article(id: article.id))
                    } label: {
                        ArticlePreviewCardView(article: article)
                            .padding(.horizontal, 8)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .task {
            await articlesVM.loadArticles()
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("Articles")
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
    ArticlesPreviewView()
}
