//
//  ArticlePreviewDTO.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import Foundation


struct ArticlesPreviewResponse: Decodable {
    let data: ArticlesPreviewData
}

struct ArticlesPreviewData: Decodable {
    let articles: [ArticlePreviewDTO]
}

struct ArticlePreviewDTO: Decodable, Identifiable {
    let id: Int
    let imageURL: String
    let level: EnglishLevel
    let minutesToRead: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "image_url"
        case level
        case minutesToRead = "minutes_to_read"
        case title
    }
    
    func toModel() -> ArticlePreview {
        ArticlePreview(
            id: id,
            imageURL: imageURL,
            level: level,
            minutesToRead: minutesToRead,
            title: title
        )
    }
}
