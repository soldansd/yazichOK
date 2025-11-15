//
//  TopicID.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 05/04/2025.
//

import Foundation

struct TopicID: Encodable {
    let id: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "topic_id"
    }
}
