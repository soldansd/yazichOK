//
//  ArticlePreviewCardView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI

struct ArticlePreviewCardView: View {
    
    let article: ArticlePreview
    
    var body: some View {
        CellCard(cornerRadius: 8) {
            HStack(spacing: 16) {
                DotAsyncImage(urlString: article.imageURL)
                    .frame(width: 75, height: 75)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                
                VStack(alignment: .leading) {
                    Text(article.title)
                        .bold()
                    
                    HStack {
                        Text("\(article.minutesToRead) min read")
                        
                        Text("•")
                        
                        Text("\(article.level) Level")
                    }
                }
                
                Spacer()
            }
        }
    }
}

#Preview {
    ArticlePreviewCardView(article: ArticlePreview(
        id: 1,
        imageURL: "https://example.com/image1.jpg",
        level: .A2,
        minutesToRead: 3,
        title: "Tips for Learning Vocabulary"
    ))
}
