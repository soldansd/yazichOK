//
//  SpeakingTopicCardView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import SwiftUI
import Lottie

struct SpeakingTopicCardView: View {
    
    let topic: Topic
    
    var body: some View {
        CellCard(alignment: .leading, spacing: 8) {
            DotAsyncImage(urlString: topic.imageURL)
                .frame(height: 40)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(topic.title)
                    .font(.title2)
                
                Text(topic.description)
                    .font(.footnote)
            }
        }
    }
    
}

#Preview {
    SpeakingTopicCardView(
        topic: Topic(
            id: 0,
            title: "Hello",
            description: "World",
            imageURL: "https://purepng.com/public/uploads/large/purepng.com-photos-iconsymbolsiconsapple-iosiosios-8-iconsios-8-721522596102asedt.png"
        )
    )
}
