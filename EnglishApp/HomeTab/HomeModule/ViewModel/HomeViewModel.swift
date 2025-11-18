//
//  HomeViewModel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

private let limit = 3
private let offset = 0

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var articles: [ArticlePreview] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    func loadArticles() async {
        isLoading = true
        errorMessage = nil

        do {
            let fetchedArticles = try await NetworkManager.shared.loadArticlesPreview(limit: limit, offset: offset)
            articles = fetchedArticles.map { $0.toModel() }
            errorMessage = nil
        } catch let error as APIError {
            errorMessage = "Error \(error.code): \(error.message)"
        } catch let error as NetworkError {
            errorMessage = error.localizedDescription
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
