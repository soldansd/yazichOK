//
//  Extension+EnglishLevel.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 09/04/2025.
//

import SwiftUI

extension EnglishLevel {
    
    var rating: Int {
        switch self {
        case .A1:
            return 1
        case .A2:
            return 2
        case .B1:
            return 3
        case .B2:
            return 4
        case .C1:
            return 5
        case .C2:
            return 6
        }
    }
    
    var pastelColor: Color {
        switch self {
        case .A1:
            return .pastelRed
        case .A2:
            return .pastelOrange
        case .B1:
            return .pastelYellow
        case .B2:
            return .pastelGreen
        case .C1:
            return .pastelCyan
        case .C2:
            return .pastelPurple
        }
    }
    
    var darkColor: Color {
        switch self {
        case .A1:
            return .darkRed
        case .A2:
            return .darkOrange
        case .B1:
            return .darkYellow
        case .B2:
            return .darkGreen
        case .C1:
            return .darkCyan
        case .C2:
            return .darkPurple
        }
    }
    
}
