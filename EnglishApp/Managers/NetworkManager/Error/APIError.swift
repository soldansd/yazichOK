//
//  NetworkError.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation

struct ErrorResponse: Decodable {
    let error: APIError
}

struct APIError: Decodable, Error {
    let code: Int
    let message: String
}
