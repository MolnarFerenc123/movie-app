//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import InjectPropertyWrapper
import Foundation
import Combine

protocol FavoritesViewModelProtocol : ObservableObject {
    var movies: [MediaItem] {get}
}

class FavoritesViewModel: FavoritesViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let request = FetchFavoriteMovieRequest()
        service.fetchFavoriteMovies(req: request)
            .receive(on: RunLoop.main)
            .sink{ completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            }receiveValue: { [weak self] movies in
                self?.movies = movies
                Favorites.favoritesId = movies
                    .map{ movie in
                        movie.id
                    }
                print("<<<<\(Favorites.favoritesId)")
            }
            .store(in: &cancellables)
        
    }
}
