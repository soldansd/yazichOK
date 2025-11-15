//
//  ArticlePreview.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import Foundation

struct ArticlePreview: Identifiable {
    let id: Int
    let imageURL: String
    let level: EnglishLevel
    let minutesToRead: Int
    let title: String
}
