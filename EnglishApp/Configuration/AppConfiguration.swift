//
//  AppConfiguration.swift
//  EnglishApp
//
//  Created by Claude on 18/11/2025.
//

import Foundation

enum Environment {
    case development
    case staging
    case production

    static var current: Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
}

struct AppConfiguration {

    // MARK: - Network Configuration

    static var baseURL: String {
        switch Environment.current {
        case .development:
            // For development, use environment variable or fallback to default
            return ProcessInfo.processInfo.environment["API_BASE_URL"] ?? "https://2f6e-194-99-105-90.ngrok-free.app"
        case .staging:
            return "https://staging-api.englishapp.com"
        case .production:
            return "https://api.englishapp.com"
        }
    }

    static var requestTimeout: TimeInterval {
        switch Environment.current {
        case .development:
            return 30.0  // Longer timeout for development/debugging
        case .staging, .production:
            return 15.0  // Shorter timeout for production
        }
    }

    // MARK: - Feature Flags

    static var enableMockData: Bool {
        Environment.current == .development
    }

    static var enableLogging: Bool {
        Environment.current == .development
    }
}
