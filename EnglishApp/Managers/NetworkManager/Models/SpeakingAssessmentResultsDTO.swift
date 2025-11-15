//
//  SpeakingAssessmentResultsDTO.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 06/04/2025.
//

import Foundation

struct AssesmentResultsResponse: Decodable {
    let data: SpeakingAssessmentResultsDTO
}

struct SpeakingAssessmentResultsDTO: Decodable {
    let overallLevel: EnglishLevel
    let topWords: [Word]
    let grammarIssues: [GrammarIssue]
    let rephraseSuggestions: [RephraseSuggestion]
    let overallFeedback: String

    enum CodingKeys: String, CodingKey {
        case overallLevel = "overall_level"
        case topWords = "top_words"
        case grammarIssues = "grammar_issues"
        case rephraseSuggestions = "rephrase_suggestions"
        case overallFeedback = "overall_feedback"
    }
    
    func toModel() -> SpeakingAssessmentResults {
        SpeakingAssessmentResults(
            overallLevel: overallLevel,
            topWords: topWords,
            grammarIssues: grammarIssues,
            rephraseSuggestions: rephraseSuggestions,
            overallFeedback: overallFeedback
        )
    }
}

struct GrammarIssue: Decodable, Hashable {
    let sentence: String
    let explanation: String
    let correctedSentence: String
    
    enum CodingKeys: String, CodingKey {
        case sentence
        case explanation
        case correctedSentence = "corrected_sentence"
    }
}

struct Word: Decodable, Hashable {
    let text: String
    let level: EnglishLevel
    
    enum CodingKeys: String, CodingKey {
        case text = "word"
        case level
    }
}

struct RephraseSuggestion: Decodable, Hashable {
    let original: String
    let suggestion: String
}

enum EnglishLevel: String, Decodable {
    case A1
    case A2
    case B1
    case B2
    case C1
    case C2

    var description: String {
        switch self {
        case .A1:
            return "Beginner"
        case .A2:
            return "Elementary"
        case .B1:
            return "Intermediate"
        case .B2:
            return "Upper Intermediate"
        case .C1:
            return "Advanced"
        case .C2:
            return "Proficient"
        }
    }
}


