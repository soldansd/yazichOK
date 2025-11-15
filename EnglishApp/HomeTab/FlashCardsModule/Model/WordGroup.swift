//
//  WordGroup.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct WordGroup: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var createdDate: Date

    init(id: UUID = UUID(), name: String, createdDate: Date = Date()) {
        self.id = id
        self.name = name
        self.createdDate = createdDate
    }
}
