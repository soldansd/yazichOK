//
//  DotAsyncImage.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI
import Lottie

struct DotAsyncImage: View {
    
    let urlString: String
    
    var body: some View {
        AsyncImage(url: URL(string: urlString)) { phase in
            switch phase {
            case .empty:
                LottieView(animation: .named("dot"))
                    .playing(loopMode: .loop)
                    .frame(width: 20, height: 20)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            case .failure:
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.gray)
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    DotAsyncImage(urlString: "")
}
