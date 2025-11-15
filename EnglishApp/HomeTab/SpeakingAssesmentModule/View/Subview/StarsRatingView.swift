//
//  StarsRatingView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import SwiftUI

struct StarsRatingView: View {
    
    let overallCount: Int
    let filledCount: Int
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<overallCount, id: \.self) { index in
                Image(systemName: index < filledCount ? "star.fill" : "star")
                    .foregroundColor(.yellow)
                    .font(.title3)
            }
        }
    }
}
