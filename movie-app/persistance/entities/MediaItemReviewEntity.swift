//
//  MediaItemStoreEntity.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//
import RealmSwift
import Foundation

class MediaItemReviewEntity: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var author: String
    @Persisted var content: String
    @Persisted var rating: Double?
    @Persisted var avatarUrlString: String?
    @Persisted var movieId: Int
}

extension MediaItemReviewEntity {
    var toDomain: MediaItemReview {
        MediaItemReview(
            id: id,
            author: author,
            content: content,
            rating: rating,
            avatarURL: avatarUrlString.flatMap(URL.init(string:))
        )
    }
    
    convenience init(from domain: MediaItemReview, movieId: Int) {
        self.init()
        self.id = domain.id
        self.author = domain.author
        self.content = domain.content
        self.rating = domain.rating
        self.avatarUrlString = domain.avatarURL?.absoluteString
        self.movieId = movieId
    }
}
