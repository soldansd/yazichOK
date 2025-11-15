//
//  EnglishAppApp.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 28/03/2025.
//

import SwiftUI

@main
struct EnglishAppApp: App {
    @StateObject private var authManager = MockAuthManager.shared

    var body: some Scene {
        WindowGroup {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                SignInView()
            }
        }
    }
}
