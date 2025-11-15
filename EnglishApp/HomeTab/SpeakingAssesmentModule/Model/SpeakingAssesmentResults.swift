//
//  SpeakingAssesmentResults.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 06/04/2025.
//

import Foundation

struct SpeakingAssessmentResults {
    let overallLevel: EnglishLevel
    let topWords: [Word]
    let grammarIssues: [GrammarIssue]
    let rephraseSuggestions: [RephraseSuggestion]
    let overallFeedback: String
}
