//
//  CellCard.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import SwiftUI

struct CellCard<Content: View>: View {
    
    let alignment: HorizontalAlignment
    let frameAlignment: Alignment
    let spacing: CGFloat
    let cornerRadius: CGFloat
    let content: Content
    
    init(
        alignment: HorizontalAlignment = .center,
        frameAlignment: Alignment = .center,
        spacing: CGFloat = 16,
        cornerRadius: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.alignment = alignment
        self.frameAlignment = frameAlignment
        self.spacing = spacing
        self.cornerRadius = cornerRadius
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: alignment, spacing: spacing) {
            content
        }
        .frame(maxWidth: .infinity, alignment: frameAlignment)
        .padding()
        .background(.appForeground)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    CellCard { EmptyView() }
}
