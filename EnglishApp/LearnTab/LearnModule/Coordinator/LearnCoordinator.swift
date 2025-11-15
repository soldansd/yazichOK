//
//  LearnCoordinator.swift
//  EnglishApp
//
//  Created by Claude on 15/11/2025.
//

import SwiftUI

class LearnCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    func push(_ screen: LearnScreen) {
        path.append(screen)
    }

    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }
}
