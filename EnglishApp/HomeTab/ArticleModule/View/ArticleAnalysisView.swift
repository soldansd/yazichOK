//
//  ArticleAnalysisView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI

struct ArticleAnalysisView: View {
    
    let article: Article
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()
            
            ScrollView {
                LazyVStack(spacing: 21) {
                    vocabulary
                    grammar
                }
            }
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
    
    private var vocabulary: some View {
        CellCard(alignment: .leading) {
            Text("Vocabulary Analysis")
                .font(.title2)
                .bold()
            
            ForEach(article.vocabulary) { wordRule in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text(wordRule.word)
                            .font(.title3)
                            .foregroundStyle(.darkBlue)
                            .bold()
                        
                        Spacer()
                        
                        Text(wordRule.partOfSpeech)
                            .font(.footnote)
                            .padding(6)
                            .background(.pastelGreen)
                            .foregroundStyle(.darkGreen)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                    }
                    
                    Text(wordRule.meaning)
                        .foregroundStyle(.gray)
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray, lineWidth: 0.3)
                )
            }
            
        }
        .padding(.horizontal)
    }
    
    private var grammar: some View {
        CellCard(alignment: .leading) {
            Text("Grammar Rules")
                .font(.title2)
                .bold()
            
            ForEach(article.rules) { rule in
                VStack(alignment: .leading, spacing: 8) {
                    Text(rule.name)
                        .font(.title3)
                        .bold()
                    Text(rule.example)
                        .frame(maxWidth: .infinity)
                        .padding(4)
                        .background(.pastelBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .font(.footnote)
                    
                    Text(rule.note)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.blue)
                        .frame(width: 4),
                    alignment: .leading
                )
            }
            
        }
        .padding(.horizontal)
    }
}

#Preview {
    NavigationStack {
        ArticleAnalysisView(article: Article(
            id: 1,
            imageURL: "https://crimes-simulations-assessments-cleaners.trycloudflare.com/topics/why_we_forget_things.png?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=admin%2F20250413%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20250413T232650Z&X-Amz-Expires=604800&X-Amz-SignedHeaders=host&X-Amz-Signature=3727a843aaa76bc8b2912630dfc3bcbc97c2a017c30e4ab74c0053d8aec99e1e",
            content: """
        Have you ever walked into a room and suddenly forgotten why you went there? This is something most people experience from time to time. Forgetting is a natural part of how our memory works.

        Our brain is constantly receiving information from the world around us. It would be impossible to remember everything, so the brain filters out the unimportant details and keeps only what it thinks is necessary. This helps us focus and stay organized, but it also means that sometimes we forget things we actually need.

        There are different types of memory: short-term memory, long-term memory, and working memory. Forgetting can happen at any stage. Sometimes, we don’t pay enough attention in the first place. Other times, we fail to review or repeat information, so it fades over time.

        Stress, lack of sleep, and distractions can also affect how well we remember things. The good news is that we can improve our memory by staying organized, practicing mindfulness, and getting enough rest.
        """,
            title: "",
            level: .B2,
            minutes: 4,
            vocabulary: [
                GrammarWord(id: 1, word: "retain", partOfSpeech: "verb", meaning: "to keep or hold in memory"),
                GrammarWord(id: 2, word: "distraction", partOfSpeech: "noun", meaning: "something that prevents you from concentrating"),
                GrammarWord(id: 3, word: "from time to time", partOfSpeech: "phrase", meaning: "occasionally"),
                GrammarWord(id: 4, word: "fades over time", partOfSpeech: "collocation", meaning: "gradually disappears"),
                GrammarWord(id: 5, word: "stay organized", partOfSpeech: "collocation", meaning: "remain in control of one's tasks/thoughts")
            ],
            rules: [
                GrammarRule(id: 1, name: "Present Perfect", example: "Have you ever walked into a room...?", note: "For life experiences without specific time"),
                GrammarRule(id: 2, name: "Passive Voice", example: "Our brain is constantly receiving information...", note: "Focus on the receiver of action"),
                GrammarRule(id: 3, name: "Zero Conditional", example: "If we don’t pay attention, we forget things.", note: "To describe general truths")
            ]
        ))
    }
}
