//
//  SearchMovie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 17..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

protocol SearchMovieViewModelProtocol : ObservableObject {
    
}

class SearchMovieViewModel: SearchMovieViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MovieServiceProtocol

    func searchMovies(searchText: String) async {
        do {
            let request = FetchMoviesByTitleRequest(searchText: searchText)
            let movies = try await service.fetchMoviesByTitle(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
}
