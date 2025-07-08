//
//  MediaItemDetail+asMediaItem.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 07. 05..
//

extension MediaItemDetail {
    func asMediaItem () -> MediaItem {
        print("Image URL: \(self.imageUrl?.absoluteString ?? "nil")")
        return MediaItem(
            id: self.id, title: self.title, year: self.year, duration: String(self.runtime), imageUrl: self.imageUrl, rating: self.rating, voteCount: self.voteCount, showType: self.showType
        )
    }
}
