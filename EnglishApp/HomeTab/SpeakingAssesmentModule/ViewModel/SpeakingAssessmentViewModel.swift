//
//  SpeakingAssessmentViewModel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 06/04/2025.
//

import Foundation

@MainActor
class SpeakingAssessmentViewModel: ObservableObject {
    
    let sessionID: UUID
    
    @Published var results: SpeakingAssessmentResults?
    
    @Published var errorMessage: String?
    
    init(sessionID: UUID) {
        self.sessionID = sessionID
    }
    
    func completeRecordingSession() async {
        do {
            let fetchedResults = try await NetworkManager.shared.completeRecordingSession(id: sessionID)
            results = fetchedResults.toModel()
            errorMessage = nil
        } catch let error as APIError {
            errorMessage = "Error \(error.code): \(error.message)"
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
    
}











//    = SpeakingAssessmentResults(
//        overallLevel: .B1,  // Intermediate level
//        topWords: [
//            Word(text: "I", level: .A1),
//            Word(text: "am", level: .A1),
//            Word(text: "happy", level: .A2),
//            Word(text: "great", level: .B1),
//            Word(text: "doing", level: .B1),
//            Word(text: "well", level: .B1)
//        ],
//        grammarIssues: [
//            GrammarIssue(sentence: "I am doing good.", explanation: "The word 'good' is incorrect. Use 'well' instead.", correctedSentence: "I am doing well."),
//            GrammarIssue(sentence: "I has gone to the store.", explanation: "Incorrect verb form. Use 'have' instead of 'has' for plural subjects.", correctedSentence: "I have gone to the store.")
//        ],
//        rephraseSuggestions: [
//            RephraseSuggestion(original: "I am so happy to be here.", suggestion: "Consider adding more details, like why you're happy."),
//            RephraseSuggestion(original: "I hope you are doing well.", suggestion: "Could be more specific, like 'I hope you're doing well on your trip'.")
//        ],
//        overallFeedback: "You have a good command of basic English, but there are some minor grammar issues. Keep practicing to improve your fluency, especially with verb tenses and word choices. Focus on elaborating on your responses."
//    )
