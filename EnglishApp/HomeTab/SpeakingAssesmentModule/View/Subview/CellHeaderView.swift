//
//  CellHeaderView.swift
//  EnglishApp
//
//  Created by Даниил Соловьев on 13/04/2025.
//

import SwiftUI

struct CellHeaderView: View {
    
    let imageName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            
            Text(text)
                .font(.title3)
                .bold()
        }
    }
}
