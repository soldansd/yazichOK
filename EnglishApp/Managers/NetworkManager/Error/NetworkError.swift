//
//  NetworkError.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation

enum NetworkError: Error {
    case badServerResponse
    case httpError(statusCode: Int)
    case timeout
    case noConnection
    case connectionFailed(Error)
    case decodingError(Error)
}

extension NetworkError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badServerResponse:
            return "The server response was invalid"
        case .httpError(let statusCode):
            return "HTTP error with status code: \(statusCode)"
        case .timeout:
            return "The request timed out. Please check your connection and try again"
        case .noConnection:
            return "No internet connection. Please check your network settings"
        case .connectionFailed(let error):
            return "Connection failed: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}
