//
//  FavoriteMediaStore.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 16..
//

import Combine

protocol FavoriteMediaStoreProtocol {
    
    var mediaItems: AnyPublisher<[MediaItem], MovieError> { get }
    
    func addFavoriteMediaItem(_ mediaItem: MediaItem)
    func addFavoriteMediaItems(_ mediaItems: [MediaItem])
    func removeFavoriteMediaItem(withId id: Int)
    
    func isFavoriteMediaItem(withId id: Int) -> Bool
    
}

class FavoriteMediaStore: FavoriteMediaStoreProtocol {
    
    private var mediaItemsSubject = CurrentValueSubject<[MediaItem], MovieError>([])
    
    private var favoriteItems: [MediaItem] = []
    
    var mediaItems: AnyPublisher<[MediaItem], MovieError> {
        mediaItemsSubject.eraseToAnyPublisher()
    }
    
    func addFavoriteMediaItems(_ mediaItems: [MediaItem]) {
        favoriteItems = mediaItems
        mediaItemsSubject.send(favoriteItems)
    }
    
    func addFavoriteMediaItem(_ mediaItem: MediaItem) {
        favoriteItems = [mediaItem]
        mediaItemsSubject.send(favoriteItems)
    }
    
    func removeFavoriteMediaItem(withId id: Int) {
        favoriteItems.removeAll { $0.id == id }
        mediaItemsSubject.send(favoriteItems)
    }
    
    func isFavoriteMediaItem(withId id: Int) -> Bool {
        favoriteItems.contains { item in
            item.id == id
        }
    }
}
