//
//  AuthenticationTests.swift
//  EnglishAppTests
//
//  Created by Claude on 15/11/2025.
//

import XCTest
import SwiftUI
@testable import EnglishApp

final class AuthenticationTests: XCTestCase {

    var authManager: MockAuthManager!

    override func setUp() async throws {
        try await super.setUp()
        // Note: Using shared instance, so we need to clean up state
        authManager = MockAuthManager.shared
        await authManager.signOut() // Clean state
    }

    override func tearDown() async throws {
        await authManager.signOut()
        try await super.tearDown()
    }

    // MARK: - User Model Tests

    func testUserInitialization() {
        // Given
        let name = "John Doe"
        let email = "john@example.com"

        // When
        let user = User(fullName: name, email: email)

        // Then
        XCTAssertEqual(user.fullName, name)
        XCTAssertEqual(user.email, email)
        XCTAssertNotNil(user.id)
        XCTAssertNotNil(user.createdDate)
    }

    func testUserEquality() {
        // Given
        let id = UUID()
        let user1 = User(id: id, fullName: "John", email: "john@test.com")
        let user2 = User(id: id, fullName: "John", email: "john@test.com")
        let user3 = User(id: UUID(), fullName: "Jane", email: "jane@test.com")

        // Then
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }

    // MARK: - Email Validation Tests

    func testValidEmail() {
        // Valid emails
        XCTAssertTrue(authManager.isValidEmail("test@example.com"))
        XCTAssertTrue(authManager.isValidEmail("user.name@example.com"))
        XCTAssertTrue(authManager.isValidEmail("user+tag@example.co.uk"))
        XCTAssertTrue(authManager.isValidEmail("test123@test.io"))
    }

    func testInvalidEmail() {
        // Invalid emails
        XCTAssertFalse(authManager.isValidEmail(""))
        XCTAssertFalse(authManager.isValidEmail("notanemail"))
        XCTAssertFalse(authManager.isValidEmail("@example.com"))
        XCTAssertFalse(authManager.isValidEmail("user@"))
        XCTAssertFalse(authManager.isValidEmail("user @example.com"))
    }

    // MARK: - Sign In Tests

    func testSignInSuccess() async throws {
        // Given - using mock user (test@example.com / password123)
        let email = "test@example.com"
        let password = "password123"

        // When
        try await authManager.signIn(email: email, password: password)

        // Then
        await MainActor.run {
            XCTAssertTrue(authManager.isAuthenticated)
            XCTAssertNotNil(authManager.currentUser)
            XCTAssertEqual(authManager.currentUser?.email, email)
        }
    }

    func testSignInWithInvalidEmail() async {
        // Given
        let email = "invalid-email"
        let password = "password123"

        // When/Then
        do {
            try await authManager.signIn(email: email, password: password)
            XCTFail("Expected AuthError.invalidEmail to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidEmail)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
            XCTAssertNil(authManager.currentUser)
        }
    }

    func testSignInWithEmptyFields() async {
        // When/Then - empty email
        do {
            try await authManager.signIn(email: "", password: "password")
            XCTFail("Expected AuthError.emptyFields to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.emptyFields)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        // When/Then - empty password
        do {
            try await authManager.signIn(email: "test@example.com", password: "")
            XCTFail("Expected AuthError.emptyFields to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.emptyFields)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignInWithNonexistentUser() async {
        // Given
        let email = "nonexistent@example.com"
        let password = "password123"

        // When/Then
        do {
            try await authManager.signIn(email: email, password: password)
            XCTFail("Expected AuthError.userNotFound to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.userNotFound)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignInWithIncorrectPassword() async {
        // Given - using mock user but wrong password
        let email = "test@example.com"
        let password = "wrongpassword"

        // When/Then
        do {
            try await authManager.signIn(email: email, password: password)
            XCTFail("Expected AuthError.incorrectPassword to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.incorrectPassword)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignInCaseInsensitiveEmail() async throws {
        // Given - test with different case
        let email = "TEST@EXAMPLE.COM"
        let password = "password123"

        // When
        try await authManager.signIn(email: email, password: password)

        // Then
        await MainActor.run {
            XCTAssertTrue(authManager.isAuthenticated)
        }
    }

    // MARK: - Sign Up Tests

    func testSignUpSuccess() async throws {
        // Given
        let fullName = "New User"
        let email = "newuser@example.com"
        let password = "newpass123"

        // When
        try await authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: password)

        // Then
        await MainActor.run {
            XCTAssertTrue(authManager.isAuthenticated)
            XCTAssertNotNil(authManager.currentUser)
            XCTAssertEqual(authManager.currentUser?.fullName, fullName)
            XCTAssertEqual(authManager.currentUser?.email, email)
        }
    }

    func testSignUpWithEmptyFields() async {
        // When/Then - empty name
        do {
            try await authManager.signUp(fullName: "", email: "test@test.com", password: "pass123", confirmPassword: "pass123")
            XCTFail("Expected AuthError.emptyFields to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.emptyFields)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        // When/Then - empty email
        do {
            try await authManager.signUp(fullName: "Name", email: "", password: "pass123", confirmPassword: "pass123")
            XCTFail("Expected AuthError.emptyFields to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.emptyFields)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignUpWithInvalidEmail() async {
        // Given
        let fullName = "Test User"
        let email = "not-an-email"
        let password = "password123"

        // When/Then
        do {
            try await authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: password)
            XCTFail("Expected AuthError.invalidEmail to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidEmail)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignUpWithShortPassword() async {
        // Given
        let fullName = "Test User"
        let email = "test@test.com"
        let password = "12345" // Less than 6 characters

        // When/Then
        do {
            try await authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: password)
            XCTFail("Expected AuthError.invalidPassword to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.invalidPassword)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignUpWithMismatchedPasswords() async {
        // Given
        let fullName = "Test User"
        let email = "test@test.com"
        let password = "password123"
        let confirmPassword = "different123"

        // When/Then
        do {
            try await authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: confirmPassword)
            XCTFail("Expected AuthError.passwordsDoNotMatch to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.passwordsDoNotMatch)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    func testSignUpWithExistingEmail() async {
        // Given - using mock user email
        let fullName = "Another User"
        let email = "test@example.com" // Already exists
        let password = "password123"

        // When/Then
        do {
            try await authManager.signUp(fullName: fullName, email: email, password: password, confirmPassword: password)
            XCTFail("Expected AuthError.emailAlreadyExists to be thrown")
        } catch let error as AuthError {
            XCTAssertEqual(error, AuthError.emailAlreadyExists)
        } catch {
            XCTFail("Unexpected error type: \(error)")
        }

        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
        }
    }

    // MARK: - Sign Out Tests

    func testSignOut() async throws {
        // Given - sign in first
        try await authManager.signIn(email: "test@example.com", password: "password123")
        await MainActor.run {
            XCTAssertTrue(authManager.isAuthenticated)
        }

        // When
        await authManager.signOut()

        // Then
        await MainActor.run {
            XCTAssertFalse(authManager.isAuthenticated)
            XCTAssertNil(authManager.currentUser)
        }
    }

    // MARK: - Auth State Persistence Tests

    func testAuthStatePersistence() async throws {
        // Given - sign in
        try await authManager.signIn(email: "test@example.com", password: "password123")
        await MainActor.run {
            XCTAssertTrue(authManager.isAuthenticated)
        }

        let userEmail = await MainActor.run { authManager.currentUser?.email }

        // When - create new instance (simulating app restart)
        // Note: In real app, this would be a new instance, but with shared singleton we can test persistence
        let isAuthStored = UserDefaults.standard.bool(forKey: "is_authenticated")
        let userData = UserDefaults.standard.data(forKey: "current_user")

        // Then
        XCTAssertTrue(isAuthStored)
        XCTAssertNotNil(userData)

        // Cleanup
        await authManager.signOut()
    }

    // MARK: - ViewModel Tests

    func testSignInViewModelValidation() {
        // Given
        let viewModel = SignInViewModel()

        // Initially invalid
        XCTAssertFalse(viewModel.isValid)

        // When - add email only
        viewModel.email = "test@example.com"
        XCTAssertFalse(viewModel.isValid)

        // When - add password
        viewModel.password = "password"

        // Then
        XCTAssertTrue(viewModel.isValid)
    }

    func testSignUpViewModelValidation() {
        // Given
        let viewModel = SignUpViewModel()

        // Initially invalid
        XCTAssertFalse(viewModel.isValid)

        // When - add all fields
        viewModel.fullName = "Test User"
        viewModel.email = "test@test.com"
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"

        // Then
        XCTAssertTrue(viewModel.isValid)
        XCTAssertTrue(viewModel.passwordsMatch)
    }

    func testSignUpViewModelPasswordMatch() {
        // Given
        let viewModel = SignUpViewModel()
        viewModel.password = "password123"
        viewModel.confirmPassword = "password123"

        // Then
        XCTAssertTrue(viewModel.passwordsMatch)

        // When - different passwords
        viewModel.confirmPassword = "different"

        // Then
        XCTAssertFalse(viewModel.passwordsMatch)
    }

    // MARK: - AuthError Tests

    func testAuthErrorDescriptions() {
        XCTAssertNotNil(AuthError.invalidEmail.errorDescription)
        XCTAssertNotNil(AuthError.invalidPassword.errorDescription)
        XCTAssertNotNil(AuthError.emailAlreadyExists.errorDescription)
        XCTAssertNotNil(AuthError.userNotFound.errorDescription)
        XCTAssertNotNil(AuthError.incorrectPassword.errorDescription)
        XCTAssertNotNil(AuthError.passwordsDoNotMatch.errorDescription)
        XCTAssertNotNil(AuthError.emptyFields.errorDescription)
    }
}
