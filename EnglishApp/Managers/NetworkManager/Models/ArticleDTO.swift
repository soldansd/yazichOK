//
//  ArticleDTO.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import Foundation

struct ArticleResponse: Decodable {
    let data: ArticleData
}

struct ArticleData: Decodable {
    let article: ArticleDTO
}

struct ArticleDTO: Decodable, Identifiable {
    let id: Int
    let imageURL: String
    let content: String
    let title: String
    let level: EnglishLevel
    let minutes: Int
    let vocabulary: [GrammarWord]
    let rules: [GrammarRule]
    
    enum CodingKeys: String, CodingKey {
        case id, content, title, level, minutes, vocabulary, rules
        case imageURL = "image_url"
    }
    
    func toModel() -> Article {
        Article(
            id: id,
            imageURL: imageURL,
            content: content,
            title: title,
            level: level,
            minutes: minutes,
            vocabulary: vocabulary,
            rules: rules
        )
    }
}

struct GrammarWord: Decodable, Identifiable, Hashable {
    let id: Int
    let word: String
    let partOfSpeech: String
    let meaning: String
    
    enum CodingKeys: String, CodingKey {
        case id, word, meaning
        case partOfSpeech = "part_of_speech"
    }
}

struct GrammarRule: Decodable, Identifiable, Hashable {
    let id: Int
    let name: String
    let example: String
    let note: String
}
