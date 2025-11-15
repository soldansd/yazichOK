//
//  ArticleView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI
import Lottie

struct ArticleView: View {
    
    @StateObject var articleVM: ArticleViewModel
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()
            
            if let article = articleVM.article {
                ScrollView {
                    DotAsyncImage(urlString: article.imageURL)
                        .frame(minHeight: 200)
                    
                    HStack {
                        timeToRead(article: article)
                        level(article: article)
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    
                    Text(article.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal)
                        .font(.title)
                        .bold()
                    
                    Text(article.content)
                        .padding(.horizontal)
                        .padding(.vertical, 2)
                    
                    Button {
                        coordinator.push(.articleAnalisis(article))
                    } label: {
                        Text("Article analysis")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.darkBlue)
                            .foregroundStyle(.appForeground)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding()
                        
                    }
                    
                }
                .ignoresSafeArea()
                .padding(.bottom)
                
            } else {
                LottieView(animation: .named("loading"))
                    .playing(loopMode: .loop)
            }
        }
        .task {
            await articleVM.getArticle()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonToolbar {
                    coordinator.pop()
                }
            }
        }
    }
    
    private func timeToRead(article: Article) -> some View {
        HStack {
            Image("clock")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            Text("\(article.minutes) min read")
                .font(.callout)
                
        }
        .padding(10)
        .bold()
        .background(.pastelCyan)
        .foregroundStyle(.darkCyan)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
    
    private func level(article: Article) -> some View {
        HStack {
            Image("stats")
                .resizable()
                .scaledToFit()
                .frame(width: 25, height: 25)
            
            Text(article.level.description)
                .font(.callout)
                
        }
        .padding(10)
        .bold()
        .background(.pastelGreen)
        .foregroundStyle(.darkGreen)
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    NavigationStack {
        ArticleView(articleVM: ArticleViewModel(articleID: 1))
    }
}
