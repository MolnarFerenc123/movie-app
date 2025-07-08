//
//  MediaItemStore.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import RealmSwift
import Combine

protocol CastMemberStoreProtocol {
    func getCastMembers(fromMovieId movieId: Int) -> AnyPublisher<[Contributor], MovieError>
    func saveCastMembers(_ items: [Contributor], forMovieId movieId: Int)
    func deleteCastMembers(fromMovieId movieId: Int)
    func deleteAll()
}

class CastMemberStore: CastMemberStoreProtocol {
    private let realm: Realm

    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }

    func getCastMembers(fromMovieId movieId: Int) -> AnyPublisher<[Contributor], MovieError> {
        let results = realm.objects(CastMemberEntity.self)
            .where {
                $0.movieId == movieId
            }
        let castMembers = results.map { $0.toDomain }
        return Just(Array(castMembers))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }

    func saveCastMembers(_ items: [Contributor], forMovieId movieId: Int) {
        let entities = items.map { cast in
            let entity = CastMemberEntity(from: cast, movieId: movieId)
            entity.movieId = movieId
            return entity
        }
        do {
            try realm.write {
                realm.add(entities, update: .modified)
            }
        } catch {
            print("Failed to save cast members: \(error)")
        }
    }

    func deleteCastMembers(fromMovieId movieId: Int) {
        do {
            let items = realm.objects(CastMemberEntity.self).filter("movieId == %@", movieId)
            try realm.write {
                realm.delete(items)
            }
        } catch {
            print("Failed to delete cast members for movie \(movieId): \(error)")
        }
    }

    func deleteAll() {
        let all = realm.objects(CastMemberEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}
