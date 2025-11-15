//
//  FlashCard.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct FlashCard: Identifiable, Codable, Hashable {
    let id: UUID
    var word: String
    var translation: String
    var exampleSentence: String
    var pronunciation: String
    var groupID: UUID
    var difficulty: DifficultyLevel
    var imageURL: String?
    var isNew: Bool
    var needsReview: Bool
    var lastReviewedDate: Date?

    init(
        id: UUID = UUID(),
        word: String,
        translation: String,
        exampleSentence: String = "",
        pronunciation: String = "",
        groupID: UUID,
        difficulty: DifficultyLevel = .medium,
        imageURL: String? = nil,
        isNew: Bool = true,
        needsReview: Bool = false,
        lastReviewedDate: Date? = nil
    ) {
        self.id = id
        self.word = word
        self.translation = translation
        self.exampleSentence = exampleSentence
        self.pronunciation = pronunciation
        self.groupID = groupID
        self.difficulty = difficulty
        self.imageURL = imageURL
        self.isNew = isNew
        self.needsReview = needsReview
        self.lastReviewedDate = lastReviewedDate
    }
}

enum DifficultyLevel: String, Codable, CaseIterable {
    case easy = "Easy"
    case medium = "Medium"
    case hard = "Hard"
}
