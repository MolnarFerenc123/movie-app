//
//  MediaItemListByGenre.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 31..
//

import SwiftUI
import Shimmer

struct MediaItemListByGenre: View {
    let genre: Genre
    let mediaItems: [MediaItem]
    @State var isExpanded: Bool = false
    
    var body: some View {
        VStack {
            GenreSectionCell(genre: genre, isExpanded: $isExpanded)
            ScrollView(.horizontal) {
                HStack(spacing: 20) {
                    ForEach(mediaItems) {mediaItem in
                        NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                            if (mediaItem.id == 0) {
                                Rectangle()
                                    .frame(width: 200, height: 100)
                                    .shimmering()
                            }else {
                                MovieCell(movie: mediaItem, imageHeight: 100, showFavouriteIcon: false)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listRowBackground(Color.clear)
            .frame(height: isExpanded ? nil : 0)
            .opacity(isExpanded ? 1 : 0)
            .disabled(isExpanded ? false : true)
            .clipped()
            .animation(.easeInOut(duration: 0.8), value: isExpanded)
        }
    }
}
