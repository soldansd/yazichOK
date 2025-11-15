//
//  TopicsViewModel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 03/04/2025.
//

import Foundation

@MainActor
class TopicsViewModel: ObservableObject {
    @Published var topics: [Topic] = []
    @Published var errorMessage: String?

    func loadTopics() async {
        do {
            let fetchedTopics = try await NetworkManager.shared.getTopics()
            topics = fetchedTopics.map { $0.toModel() }
            print(topics)
            errorMessage = nil
        } catch let error as APIError {
            errorMessage = "Error \(error.code): \(error.message)"
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
}
