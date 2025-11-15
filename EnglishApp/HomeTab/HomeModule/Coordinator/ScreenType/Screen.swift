//
//  Screen.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import Foundation

enum Screen: Hashable {
    case topicsList
    case audioRecording(topicID: Int)
    case assesmentResults(sessionId: UUID)
    case articlesPreview
    case article(id: Int)
    case articleAnalisis(Article)
    case flashCards
    case addNewWord
    case addNewWordsGroup
    case memoriseWords(groupID: UUID)
}
