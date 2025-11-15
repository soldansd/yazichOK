//
//  BackButtonToolbar.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI

struct BackButtonToolbar: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .bold()
        }
    }
}

#Preview {
    BackButtonToolbar {}
}
