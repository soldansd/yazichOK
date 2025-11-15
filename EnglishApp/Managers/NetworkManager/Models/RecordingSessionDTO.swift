//
//  SessionDTO.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 05/04/2025.
//

import Foundation

struct SessionResponse: Decodable {
    let data: SessionData
}

struct SessionData: Decodable {
    let session: RecordingSessionDTO
}

struct RecordingSessionDTO: Decodable, Identifiable {
    let id: UUID
    let topicQuestions: TopicQuestions
    
    enum CodingKeys: String, CodingKey {
        case id
        case topicQuestions = "topic"
    }
    
    func toModel() -> RecordingSession {
        RecordingSession(id: id, topicQuestions: topicQuestions)
    }
}

struct TopicQuestions: Decodable {
    let id: Int
    let questions: [Question]
}

struct Question: Decodable, Equatable {
    let id: Int
    let text: String
}
