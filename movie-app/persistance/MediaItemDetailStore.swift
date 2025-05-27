//
//  MediaItemStore.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import RealmSwift
import Combine

protocol MediaItemDetailStoreProtocol {
    func getMediaItemDetail(withId id: Int) -> AnyPublisher<MediaItemDetail, MovieError>
    func saveMediaItemDetail(_ item: MediaItemDetail)
    func deleteMediaItemDetail(withId id: Int)
    func deleteAll()
}

class MediaItemDetailStore: MediaItemDetailStoreProtocol {
    private let realm: Realm

    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Realm")
        }
        self.realm = realm
    }

    func getMediaItemDetail(withId id: Int) -> AnyPublisher<MediaItemDetail, MovieError> {
        let detail = realm.object(ofType: MediaItemDetailEntity.self, forPrimaryKey: id)?.toDomain ?? MediaItemDetail()
        
        return Just(detail)
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }

    func saveMediaItemDetail(_ item: MediaItemDetail) {
        let entity = MediaItemDetailEntity(from: item)
        try? realm.write {
            realm.add(entity, update: .modified)
        }
    }

    func deleteMediaItemDetail(withId id: Int) {
        if let entity = realm.object(ofType: MediaItemDetailEntity.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(entity)
            }
        }
    }

    func deleteAll() {
        let all = realm.objects(MediaItemDetailEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }
}
