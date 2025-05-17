//
//  MediaItemStore.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import RealmSwift
import Combine

protocol MediaItemStoreProtocol {
    var mediaItems: AnyPublisher<[MediaItem], MovieError> { get }
    
    func saveMediaItems(_ items: [MediaItem])
    func deleteMediaItem(withId id: Int)
    func deleteAll()
    
    func isMediaItemStored(withId id: Int) -> Bool
}

class MediaItemStore: MediaItemStoreProtocol {
    private let realm: Realm
    private var notificationToken: NotificationToken?
    private let subject = CurrentValueSubject<[MediaItem], MovieError>([])
    
    var mediaItems: AnyPublisher<[MediaItem], MovieError> {
        subject.eraseToAnyPublisher()
    }
    
    init() {
        guard let realm = try? Realm() else {
            fatalError("Failed to initialize Reachability")
        }
        
        self.realm = realm
        observeMediaItems()
    }

    private func observeMediaItems() {
        let results = realm.objects(MediaItemEntity.self)
        notificationToken = results.observe { [weak self] changes in
            switch changes {
            case .initial(let items),
                 .update(let items, _, _, _):
                self?.subject.send(items.map { $0.toDomain })
            case .error(let error):
                print("Realm observe error: \(error)")
            }
        }
    }

    func saveMediaItems(_ items: [MediaItem]) {
        let entities = items.map { item in
            MediaItemEntity(from: item)
        }
        try? realm.write {
            realm.add(entities, update: .modified)
        }
    }

    func deleteMediaItem(withId id: Int) {
        if let object = realm.object(ofType: MediaItemEntity.self, forPrimaryKey: id) {
            try? realm.write {
                realm.delete(object)
            }
        }
    }

    func deleteAll() {
        let all = realm.objects(MediaItemEntity.self)
        try? realm.write {
            realm.delete(all)
        }
    }

    func isMediaItemStored(withId id: Int) -> Bool {
        realm.object(ofType: MediaItemEntity.self, forPrimaryKey: id) != nil
    }

    deinit {
        notificationToken?.invalidate()
    }
}
