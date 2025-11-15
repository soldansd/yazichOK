//
//  Article.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import Foundation

struct Article: Identifiable, Hashable {
    let id: Int
    let imageURL: String
    let content: String
    let title: String
    let level: EnglishLevel
    let minutes: Int
    let vocabulary: [GrammarWord]
    let rules: [GrammarRule]
}
