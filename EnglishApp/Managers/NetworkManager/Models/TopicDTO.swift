//
//  TopicDTO.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation

struct TopicsResponse: Decodable {
    let data: TopicsData
}

struct TopicsData: Decodable {
    let topics: [TopicDTO]
}

struct TopicDTO: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let imageUrl: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrl = "photo_url"
    }
    
    func toModel() -> Topic {
        Topic(id: id, title: title, description: description, imageURL: imageUrl)
    }
}
