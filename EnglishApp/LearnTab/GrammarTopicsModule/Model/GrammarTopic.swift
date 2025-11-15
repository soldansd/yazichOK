//
//  GrammarTopic.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct GrammarTopic: Identifiable, Hashable {
    let id: String
    let name: String
    let description: String
    let questionCount: Int

    init(id: String, name: String, description: String, questionCount: Int) {
        self.id = id
        self.name = name
        self.description = description
        self.questionCount = questionCount
    }
}

// MARK: - Mock Data
extension GrammarTopic {
    static let mockTopics: [GrammarTopic] = [
        GrammarTopic(
            id: "present-simple",
            name: "Present Simple",
            description: "Learn how to use the present simple tense",
            questionCount: 20
        ),
        GrammarTopic(
            id: "past-simple",
            name: "Past Simple",
            description: "Master the past simple tense",
            questionCount: 15
        ),
        GrammarTopic(
            id: "present-continuous",
            name: "Present Continuous",
            description: "Practice present continuous tense",
            questionCount: 18
        ),
        GrammarTopic(
            id: "future-simple",
            name: "Future Simple",
            description: "Learn about future simple tense",
            questionCount: 12
        ),
        GrammarTopic(
            id: "articles",
            name: "Articles (a, an, the)",
            description: "Master the use of English articles",
            questionCount: 25
        ),
        GrammarTopic(
            id: "prepositions",
            name: "Prepositions",
            description: "Learn common prepositions and their usage",
            questionCount: 20
        ),
        GrammarTopic(
            id: "modal-verbs",
            name: "Modal Verbs",
            description: "Practice using can, could, should, must, etc.",
            questionCount: 16
        ),
        GrammarTopic(
            id: "conditionals",
            name: "Conditionals",
            description: "Master if-clauses and conditional sentences",
            questionCount: 14
        )
    ]
}
