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
        ZStack {
            NavigationLink(destination: MovieListView(genre:genre)){
                EmptyView()
            }
            .opacity(0)
            
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
}
