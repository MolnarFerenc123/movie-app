//
//  MediaItemStoreEntity.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import RealmSwift
import Foundation

class MediaItemEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var duration: String
    @Persisted var imageUrlString: String?
    @Persisted var rating: Double
    @Persisted var voteCount: Int
}

extension MediaItemEntity {
    var toDomain: MediaItem {
        MediaItem(
            id: id,
            title: title,
            year: year,
            duration: duration,
            imageUrl: imageUrlString.flatMap(URL.init(string:)),
            rating: rating,
            voteCount: voteCount
        )
    }

    convenience init(from domain: MediaItem) {
        self.init()
        self.id = domain.id
        self.title = domain.title
        self.year = domain.year
        self.duration = domain.duration
        self.imageUrlString = domain.imageUrl?.absoluteString
        self.rating = domain.rating
        self.voteCount = domain.voteCount
    }
}
