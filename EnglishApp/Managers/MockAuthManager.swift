//
//  MockAuthManager.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import Foundation
import Combine

enum AuthError: LocalizedError {
    case invalidEmail
    case invalidPassword
    case emailAlreadyExists
    case userNotFound
    case incorrectPassword
    case passwordsDoNotMatch
    case emptyFields

    var errorDescription: String? {
        switch self {
        case .invalidEmail:
            return "Please enter a valid email address"
        case .invalidPassword:
            return "Password must be at least 6 characters"
        case .emailAlreadyExists:
            return "An account with this email already exists"
        case .userNotFound:
            return "No account found with this email"
        case .incorrectPassword:
            return "Incorrect password"
        case .passwordsDoNotMatch:
            return "Passwords do not match"
        case .emptyFields:
            return "Please fill in all fields"
        }
    }
}

@MainActor
final class MockAuthManager: ObservableObject {
    static let shared = MockAuthManager()

    @Published private(set) var isAuthenticated = false
    @Published private(set) var currentUser: User?

    private var users: [String: (password: String, user: User)] = [:]
    private let isAuthenticatedKey = "is_authenticated"
    private let currentUserKey = "current_user"

    private init() {
        loadAuthState()
        setupMockUsers()
    }

    // MARK: - Sign In

    func signIn(email: String, password: String) async throws {
        // Validate inputs
        guard !email.isEmpty, !password.isEmpty else {
            throw AuthError.emptyFields
        }

        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        // Check if user exists
        guard let userData = users[email.lowercased()] else {
            throw AuthError.userNotFound
        }

        // Check password
        guard userData.password == password else {
            throw AuthError.incorrectPassword
        }

        // Update UI state (already on main thread)
        self.currentUser = userData.user
        self.isAuthenticated = true

        // Save state
        saveAuthState()
    }

    // MARK: - Sign Up

    func signUp(fullName: String, email: String, password: String, confirmPassword: String) async throws {
        // Validate inputs
        guard !fullName.isEmpty, !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            throw AuthError.emptyFields
        }

        guard isValidEmail(email) else {
            throw AuthError.invalidEmail
        }

        guard password.count >= 6 else {
            throw AuthError.invalidPassword
        }

        guard password == confirmPassword else {
            throw AuthError.passwordsDoNotMatch
        }

        // Check if email already exists
        guard users[email.lowercased()] == nil else {
            throw AuthError.emailAlreadyExists
        }

        // Create new user (thread-safe now with @MainActor)
        let newUser = User(fullName: fullName, email: email)
        users[email.lowercased()] = (password: password, user: newUser)

        // Update UI state (already on main thread)
        self.currentUser = newUser
        self.isAuthenticated = true

        // Save state
        saveAuthState()
    }

    // MARK: - Sign Out

    func signOut() async {
        // Update UI state (already on main thread)
        self.currentUser = nil
        self.isAuthenticated = false

        // Clear state
        clearAuthState()
    }

    // MARK: - Validation

    func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }

    // MARK: - Persistence

    private func saveAuthState() {
        // Save authentication state
        UserDefaults.standard.set(self.isAuthenticated, forKey: self.isAuthenticatedKey)

        // Save user data with error handling
        if let user = self.currentUser {
            do {
                let encoded = try JSONEncoder().encode(user)
                UserDefaults.standard.set(encoded, forKey: self.currentUserKey)

                if AppConfiguration.enableLogging {
                    print("✅ MockAuthManager: Successfully saved user data")
                }
            } catch {
                print("❌ MockAuthManager: Failed to encode user - \(error.localizedDescription)")
                // Continue execution - auth state is still saved
            }
        }
    }

    private func loadAuthState() {
        // Load authentication state
        let authenticated = UserDefaults.standard.bool(forKey: isAuthenticatedKey)
        var user: User? = nil

        // Load user data with error handling
        if let userData = UserDefaults.standard.data(forKey: currentUserKey) {
            do {
                user = try JSONDecoder().decode(User.self, from: userData)

                if AppConfiguration.enableLogging {
                    print("✅ MockAuthManager: Successfully loaded user data")
                }
            } catch {
                print("⚠️ MockAuthManager: Failed to decode user - \(error.localizedDescription)")
                print("Corrupted user data will be cleared.")
                // Clear corrupted data
                UserDefaults.standard.removeObject(forKey: currentUserKey)
                user = nil
            }
        }

        self.isAuthenticated = authenticated
        self.currentUser = user
    }

    private func clearAuthState() {
        UserDefaults.standard.removeObject(forKey: isAuthenticatedKey)
        UserDefaults.standard.removeObject(forKey: currentUserKey)
    }

    // MARK: - Mock Data

    private func setupMockUsers() {
        // Create a test user
        let testUser = User(fullName: "Test User", email: "test@example.com")
        users["test@example.com"] = (password: "password123", user: testUser)

        let alexUser = User(fullName: "Alex Johnson", email: "alex@example.com")
        users["alex@example.com"] = (password: "alex123", user: alexUser)
    }
}
