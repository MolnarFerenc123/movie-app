//
//  ProductionCompanyEntity.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 20..
//

import RealmSwift

class ContributorEntity: Object {
    @Persisted var id: Int
    @Persisted var logoPath: String?
    @Persisted var name: String

    convenience init(from model: Contributor) {
        self.init()
        self.id = model.id
        self.logoPath = model.logoPath
        self.name = model.name
    }

    var toDomain: Contributor {
        Contributor(id: id, name: name, logoPath: logoPath ?? "")
    }
}
