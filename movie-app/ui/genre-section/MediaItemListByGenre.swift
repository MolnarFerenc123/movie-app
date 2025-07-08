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
                                MovieCell(movie: mediaItem, imageHeight: 100, imageWidth: 200, showFavouriteIcon: false)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .listRowBackground(Color.clear)
            .clipped()
        }
    }
}
