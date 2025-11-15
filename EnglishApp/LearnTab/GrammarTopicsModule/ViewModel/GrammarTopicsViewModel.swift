//
//  GrammarTopicsViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation

@MainActor
class GrammarTopicsViewModel: ObservableObject {
    @Published var topics: [GrammarTopic] = []
    @Published var isLoading: Bool = false

    init() {
        loadTopics()
    }

    func loadTopics() {
        isLoading = true
        // Simulate loading delay (can be replaced with network call later)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.topics = GrammarTopic.mockTopics
            self?.isLoading = false
        }
    }
}
