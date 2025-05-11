//
//  SearchMovie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 17..
//

import Combine
import InjectPropertyWrapper
import Foundation

protocol SearchViewModelProtocol : ObservableObject {
    var movies: [MediaItem] {get}
    var searchText: String {get set}
}

class SearchViewModel: SearchViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var searchText: String = ""
    @Published var alertModel: AlertModel? = nil
    
    let startSearch = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol

    init(){
        startSearch
            .debounce(for: .seconds(2.5), scheduler: RunLoop.main)
            .flatMap { [weak self]_ -> AnyPublisher<[MediaItem], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = SearchMovieRequest(query: self.searchText, includeAdult: true)
                return self.service.searchMovies(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
    }
}
