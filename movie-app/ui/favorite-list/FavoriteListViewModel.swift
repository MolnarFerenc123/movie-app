//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

protocol FavoriteListViewModelProtocol : ObservableObject {
    
}

class FavoriteListViewModel: FavoriteListViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var movieService: MovieServiceProtocol

    
    
    func loadFavorites() async {
        do {
            let request = FetchFavoritesRequest()
            let movies = try await movieService.fetchFavorites(req: request)
            
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetchin genres: \(movies)")
        }
    }
}
