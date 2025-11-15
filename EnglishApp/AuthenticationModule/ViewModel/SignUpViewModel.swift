//
//  SignUpViewModel.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var fullName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var errorMessage: String?
    @Published var isLoading = false

    private let authManager = MockAuthManager.shared

    var isValid: Bool {
        !fullName.isEmpty && !email.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
    }

    var passwordsMatch: Bool {
        password == confirmPassword
    }

    func signUp() async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }

        do {
            try authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
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
