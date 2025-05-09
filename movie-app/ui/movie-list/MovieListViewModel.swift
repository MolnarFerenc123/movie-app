//
//  MovieListView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper
import Combine

protocol MovieListViewModelProtocol: ObservableObject {
    
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    @Published var movies: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    func loadMovies(by genreId: Int) {
        let request = FetchMoviesRequest(genreId: genreId)
        service.fetchMovies(req: request)
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
