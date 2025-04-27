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
    
    @Published var searchText = ""
    @Published var debouncedSearchText = ""
    
    @Inject
    private var service: MovieServiceProtocol

    init(){
        setupDebounce()
    }
    
    func searchMovies() async {
        do {
            let request = FetchMoviesByTitleRequest(searchText: self.searchText)
            let movies = try await service.fetchMoviesByTitle(req: request)
            DispatchQueue.main.async {
                self.movies = movies
                print(self.movies)
            }
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
    
    func setupDebounce(){
        debouncedSearchText = self.searchText
        $searchText
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .assign(to: &$debouncedSearchText)
    }
}
