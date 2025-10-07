//
//  MediaItemStoreEntity.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import Foundation
import RealmSwift

class MediaItemDetailEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var title: String
    @Persisted var year: String
    @Persisted var runtime: Int
    @Persisted var imageUrl: String?
    @Persisted var rating: Double
    @Persisted var voteCount: Int
    @Persisted var overview: String
    @Persisted var popularity: Double
    @Persisted var adult: Bool
    @Persisted var genres: List<String>
    @Persisted var spokenLanguages: String
    @Persisted var imdbURL: String?
    @Persisted var productionCompanies: List<ContributorEntity>

    convenience init(from model: MediaItemDetail) {
        self.init()
        self.id = model.id
        self.title = model.title
        self.year = model.year
        self.runtime = model.runtime
        self.imageUrl = model.imageUrl?.absoluteString
        self.rating = model.rating
        self.voteCount = model.voteCount
        self.overview = model.overview
        self.popularity = model.popularity
        self.adult = model.adult
        self.genres.append(objectsIn: model.genres)
        self.spokenLanguages = model.langList
        self.imdbURL = model.imdbURL?.absoluteString
        self.productionCompanies.append(objectsIn: model.productionCompanies.map(ContributorEntity.init))
    }

    var toDomain: MediaItemDetail {
        return MediaItemDetail(
            id: id,
            title: title,
            year: year,
            runtime: runtime,
            imageUrl: imageUrl.flatMap(URL.init),
            rating: rating,
            voteCount: voteCount,
            popularity: popularity,
            adult: adult,
            genres: Array(genres),
            spokenLanguages: [spokenLanguages],
            overview: overview,
            imdbURL: imdbURL.flatMap(URL.init),
            productionCompanies: productionCompanies.map { $0.toDomain },
            showType: .unknown
        )
    }
}
