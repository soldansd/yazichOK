//
//  AudioMaterial.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

struct AudioMaterial: Identifiable, Hashable {
    let id: String
    let title: String
    let filename: String? // For local audio files
    let url: String? // For network audio
    let duration: TimeInterval // in seconds
    let difficulty: DifficultyLevel
    let isLocked: Bool
    let category: String

    enum DifficultyLevel: String, Codable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
    }

    var durationFormatted: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        if minutes > 0 {
            return "\(minutes):\(String(format: "%02d", seconds)) mins"
        } else {
            return "\(seconds) secs"
        }
    }

    init(id: String, title: String, filename: String? = nil, url: String? = nil, duration: TimeInterval, difficulty: DifficultyLevel, isLocked: Bool = false, category: String = "General") {
        self.id = id
        self.title = title
        self.filename = filename
        self.url = url
        self.duration = duration
        self.difficulty = difficulty
        self.isLocked = isLocked
        self.category = category
    }
}

// MARK: - Mock Data
extension AudioMaterial {
    static let mockAudioMaterials: [AudioMaterial] = [
        AudioMaterial(
            id: "business-meeting",
            title: "A special restaurant",
            filename: "Audio_zone-A_special_restaurant.mp3",
            duration: 241,
            difficulty: .intermediate,
            isLocked: false,
            category: "Business"
        ),
        AudioMaterial(
            id: "job-interview",
            title: "Study trip UK",
            filename: "Audio_zone_study_trip_UK.mp3",
            duration: 227,
            difficulty: .intermediate,
            isLocked: false,
            category: "Business"
        ),
        AudioMaterial(
            id: "daily-news",
            title: "London life",
            filename: "Audio_zone-London_life.mp3",
            duration: 198,
            difficulty: .advanced,
            isLocked: false,
            category: "News"
        ),
        AudioMaterial(
            id: "casual-conversation",
            title: "Marathon running",
            filename: "Audio_zone-Marathon_running.mp3",
            duration: 237,
            difficulty: .beginner,
            isLocked: false,
            category: "Conversation"
        ),
        AudioMaterial(
            id: "travel-dialogue",
            title: "Travel Dialogue",
            filename: "travel_dialogue.mp3",
            duration: 180, // 3:00
            difficulty: .beginner,
            isLocked: false,
            category: "Travel"
        ),
        AudioMaterial(
            id: "restaurant-ordering",
            title: "Restaurant Ordering",
            filename: "restaurant_ordering.mp3",
            duration: 150, // 2:30
            difficulty: .beginner,
            isLocked: false,
            category: "Daily Life"
        ),
        AudioMaterial(
            id: "phone-call",
            title: "Making a Phone Call",
            filename: "phone_call.mp3",
            duration: 135, // 2:15
            difficulty: .intermediate,
            isLocked: true,
            category: "Communication"
        ),
        AudioMaterial(
            id: "shopping-conversation",
            title: "Shopping Conversation",
            filename: "shopping_conversation.mp3",
            duration: 200, // 3:20
            difficulty: .beginner,
            isLocked: false,
            category: "Shopping"
        ),
        AudioMaterial(
            id: "weather-report",
            title: "Weather Report",
            filename: "weather_report.mp3",
            duration: 90, // 1:30
            difficulty: .beginner,
            isLocked: false,
            category: "News"
        ),
        AudioMaterial(
            id: "tech-discussion",
            title: "Technology Discussion",
            filename: "tech_discussion.mp3",
            duration: 300, // 5:00
            difficulty: .advanced,
            isLocked: true,
            category: "Technology"
        )
    ]
}
