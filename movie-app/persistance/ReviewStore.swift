//
//  ReviewStore.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 07. 05..
//
import RealmSwift
import Combine

protocol ReviewStoreProtocol {
    func getReviews(fromMovieId movieId: Int) -> AnyPublisher<[MediaItemReview], MovieError>
    func saveReviews(_ items: [MediaItemReview], forMovieId movieId: Int)
    func deleteReviews(fromMovieId movieId: Int)
    func deleteAll()
}

class ReviewStore: ReviewStoreProtocol {
    private let realm: Realm

    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }

    func getReviews(fromMovieId movieId: Int) -> AnyPublisher<[MediaItemReview], MovieError> {
        let results = realm.objects(MediaItemReviewEntity.self)
            .where {
                $0.movieId == movieId
            }
        let reviews = results.map { $0.toDomain }
        return Just(Array(reviews))
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }

    func saveReviews(_ items: [MediaItemReview], forMovieId movieId: Int) {
        let entities = items.map { review in
            let entity = MediaItemReviewEntity(from: review, movieId: movieId)
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

    func deleteReviews(fromMovieId movieId: Int) {
        do {
            let items = realm.objects(MediaItemReviewEntity.self).filter("movieId == %@", movieId)
            try realm.write {
                realm.delete(items)
            }
        } catch {
            print("Failed to delete cast members for movie \(movieId): \(error)")
        }
    }

    func deleteAll() {
        let all = realm.objects(MediaItemReviewEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}
