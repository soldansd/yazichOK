//
//  SpeakingAssesmentView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 06/04/2025.
//

import SwiftUI
import Lottie

struct SpeakingAssesmentView: View {
    
    @StateObject var assesmentVM: SpeakingAssessmentViewModel
    @EnvironmentObject private var coordinator: HomeCoordinator
    
    var body: some View {
        
        ZStack {
            Rectangle()
                .fill(.appBackground)
                .ignoresSafeArea()
            
            VStack {
                if let results = assesmentVM.results {
                    ZStack {
                        Rectangle()
                            .fill(.ultraThickMaterial)
                            .ignoresSafeArea()
                        ScrollView {
                            VStack(spacing: 16) {
                                languageLevel(results: results)
                                vocabulary(results: results)
                                grammar(results: results)
                                rephrase(results: results)
                                feedback(results: results)
                            }
                        }
                    }
                } else {
                    LottieView(animation: .named("wavesLoading"))
                        .playing(loopMode: .loop)
                        .frame(width: 250, height: 250)
                    
                    Text("We are processing your results...")
                        .font(.title3)
                        .bold()
                }
            }
        }
        .task {
            await assesmentVM.completeRecordingSession()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                BackButtonToolbar {
                    coordinator.popToRoot()
                }
            }
        }
    }
    
    private func languageLevel(results: SpeakingAssessmentResults) -> some View {
        CellCard(spacing: 8) {
            Text(results.overallLevel.rawValue)
                .font(.largeTitle)
                .bold()
            
            Text(results.overallLevel.description)
                .bold()
            
            StarsRatingView(overallCount: 6, filledCount: results.overallLevel.rating)
        }
        .padding(.horizontal)
    }
    
    private func vocabulary(results: SpeakingAssessmentResults) -> some View {
        CellCard(alignment: .leading) {
            CellHeaderView(imageName: "book", text: "Advanced vocabulary used")
            
            VStack(spacing: 8) {
                ForEach(results.topWords, id: \.self) { word in
                    HStack {
                        Text(word.text)
                        
                        Spacer()
                        
                        Text(word.level.description)
                    }
                    .padding(8)
                    .background(word.level.pastelColor)
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .foregroundColor(word.level.darkColor)
                }
            }
        }
        .padding(.horizontal)
    }
    
    private func grammar(results: SpeakingAssessmentResults) -> some View {
        CellCard(alignment: .leading) {
            CellHeaderView(imageName: "grammar", text: "Grammar Issues")
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(results.grammarIssues.enumerated()), id: \.element) { index, issue in
                    Text(issue.sentence)
                        .foregroundStyle(.red)
                        .strikethrough()
                    
                    Text(issue.correctedSentence)
                        .foregroundStyle(.green)
                    
                    Text(issue.explanation)
                    
                    if index != results.grammarIssues.count - 1 {
                        Divider()
                    }
                }
                
            }
        }
        .padding(.horizontal)
    }
    
    private func rephrase(results: SpeakingAssessmentResults) -> some View {
        CellCard(alignment: .leading) {
            CellHeaderView(imageName: "rephrase", text: "Rephrase Suggestions")
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(Array(results.rephraseSuggestions.enumerated()), id: \.element) { index, suggestion in
                    
                    Text("Original: \"\(suggestion.original)\"")
                    
                    Text("Suggestion: \"\(suggestion.suggestion)\"")
                        .foregroundStyle(.purple)
                    
                    if index != results.grammarIssues.count - 1 {
                        Divider()
                    }
                }
                
            }
        }
        .padding(.horizontal)
    }
    
    private func feedback(results: SpeakingAssessmentResults) -> some View {
        CellCard(alignment: .leading) {
            CellHeaderView(imageName: "overall", text: "Overall Feedback")
            
            Text(results.overallFeedback)
        }
        .padding(.horizontal)
    }
    
}

#Preview {
    NavigationStack {
        SpeakingAssesmentView(assesmentVM: SpeakingAssessmentViewModel(sessionID: UUID()))
    }
}




