//
//  ArticlePreviewViewModel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import Foundation

@MainActor
class ArticlePreviewViewModel: ObservableObject {
    @Published var articles: [ArticlePreview] = []
    @Published var errorMessage: String?

    func loadArticles() async {
        do {
            let fetchedArticles = try await NetworkManager.shared.loadArticlesPreview(limit: 50, offset: 0)
            articles = fetchedArticles.map { $0.toModel() }
            errorMessage = nil
        } catch let error as APIError {
            errorMessage = "Error \(error.code): \(error.message)"
        } catch {
            errorMessage = "Unexpected error: \(error.localizedDescription)"
        }
    }
}
