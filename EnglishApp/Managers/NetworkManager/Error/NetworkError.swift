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
    case fileNotFound(URL)
    case fileTooLarge(size: Int64, maxSize: Int64)
    case invalidFileType(expected: String, actual: String)
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
        case .fileNotFound(let url):
            return "File not found at: \(url.path)"
        case .fileTooLarge(let size, let maxSize):
            let sizeMB = Double(size) / 1_048_576
            let maxSizeMB = Double(maxSize) / 1_048_576
            return String(format: "File is too large (%.1f MB). Maximum size is %.1f MB", sizeMB, maxSizeMB)
        case .invalidFileType(let expected, let actual):
            return "Invalid file type. Expected \(expected), but got \(actual)"
        }
    }
}
