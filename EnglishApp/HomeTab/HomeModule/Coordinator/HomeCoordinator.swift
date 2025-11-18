//
//  HomeCoordinator.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import SwiftUI

@MainActor
class HomeCoordinator: ObservableObject {
    @Published var path = NavigationPath()
    
    func push(_ screen: Screen) {
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
