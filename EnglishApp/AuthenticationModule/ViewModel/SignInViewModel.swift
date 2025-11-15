//
//  SignInViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

class SignInViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authManager = MockAuthManager.shared

    var isValid: Bool {
        !email.isEmpty && !password.isEmpty
    }

    func signIn() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            try await authManager.signIn(email: email, password: password)
            await MainActor.run {
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }

    func clearError() {
        errorMessage = nil
    }
}
