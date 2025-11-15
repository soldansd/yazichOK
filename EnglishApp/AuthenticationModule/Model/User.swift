//
//  User.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct User: Identifiable, Codable, Equatable {
    let id: UUID
    var fullName: String
    var email: String
    var createdDate: Date

    init(id: UUID = UUID(), fullName: String, email: String, createdDate: Date = Date()) {
        self.id = id
        self.fullName = fullName
        self.email = email
        self.createdDate = createdDate
    }
}
