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
    
    let viewLoaded = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    init() {
        viewLoaded
            .flatMap { [weak self] _ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchFavoriteMovieRequest()
                return repository.fetchFavoriteMovies(req: request, fromLocal: false)
            }
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
