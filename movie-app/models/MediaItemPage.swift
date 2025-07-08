//
//  Movie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//
import Foundation

struct MediaItemPage {
    let mediaItems: [MediaItem]
    let totalPages: Int
    
    init(dto: MoviePageResponse) {
        self.mediaItems = dto.results
                            .map(MediaItem.init)
        self.totalPages = dto.totalPages
    }
    
    init(dto: TVPageResponse) {
        self.mediaItems = dto.results
                            .map(MediaItem.init)
        self.totalPages = dto.totalPages
    }
}
