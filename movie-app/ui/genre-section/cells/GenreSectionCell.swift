//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell : View {
    var genre : Genre
    
    var body: some View {
        HStack{
            Text(genre.name)
                .font(Fonts.title)
                .foregroundStyle(.primary)
                .accessibilityLabel(genre.name)
            Spacer()
            Image(.rightArrow)
        }
    }
}
