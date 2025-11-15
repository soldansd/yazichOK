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
            title: "Business Meeting Discussion",
            filename: "business_meeting.mp3",
            duration: 225, // 3:45
            difficulty: .intermediate,
            isLocked: false,
            category: "Business"
        ),
        AudioMaterial(
            id: "job-interview",
            title: "Job Interview Practice",
            filename: "job_interview.mp3",
            duration: 270, // 4:30
            difficulty: .intermediate,
            isLocked: true,
            category: "Business"
        ),
        AudioMaterial(
            id: "daily-news",
            title: "Daily News Report",
            filename: "daily_news.mp3",
            duration: 165, // 2:45
            difficulty: .advanced,
            isLocked: true,
            category: "News"
        ),
        AudioMaterial(
            id: "casual-conversation",
            title: "Casual Conversation",
            filename: "casual_conversation.mp3",
            duration: 195, // 3:15
            difficulty: .beginner,
            isLocked: true,
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
