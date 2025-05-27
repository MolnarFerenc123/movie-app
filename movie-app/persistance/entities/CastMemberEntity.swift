//
//  ProductionCompanyEntity.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 20..
//

import RealmSwift

class CastMemberEntity: Object {
    @Persisted(primaryKey: true) var id: Int
    @Persisted var imageUrlString: String?
    @Persisted var name: String
    @Persisted var movieId: Int

    convenience init(from model: Contributor, movieId: Int) {
        self.init()
        self.id = model.id
        self.imageUrlString = model.profileImageUrl?.absoluteString
        self.name = model.name
        self.movieId = movieId
    }

    var toDomain: Contributor {
        Contributor(id: id, name: name, logoPath: imageUrlString ?? "")
    }
}
