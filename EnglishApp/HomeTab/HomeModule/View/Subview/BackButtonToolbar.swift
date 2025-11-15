//
//  BackButtonToolbar.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 14/04/2025.
//

import SwiftUI

struct BackButtonToolbar: View {
    var dismissAction: (() -> Void)? = nil
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        Button {
            if let dismissAction {
                dismissAction()
            } else {
                dismiss()
            }
        } label: {
            Image(systemName: "chevron.left")
                .bold()
        }
    }
}

#Preview {
    BackButtonToolbar()
}
