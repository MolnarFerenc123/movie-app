//
//  GenreSectionCell.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//

import SwiftUI

struct GenreSectionCell : View {
    var genre : Genre
    @Binding var isExpanded: Bool
    
    var body: some View {
        NavigationLink(destination: MovieListView(genre:genre)){
            HStack{
                Text(genre.name)
                    .font(Fonts.title)
                    .foregroundStyle(.primary)
                    .accessibilityLabel(genre.name)
                Spacer()
                RotatingArrow(isExpanded: isExpanded)
                    .onTapGesture {
                        isExpanded.toggle()
                    }
            }
        }
        
    }
}
