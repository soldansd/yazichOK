//
//  ProgressCircleBar.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 05/04/2025.
//

import SwiftUI

struct ProgressCircleBar: View {
    @Binding var progress: Double
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 8)
                .opacity(0.3)
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .rotationEffect(.degrees(270))
                .foregroundColor(color)
        }
    }
}
