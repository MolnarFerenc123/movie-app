//
//  MovieListView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import InjectPropertyWrapper
import Combine
import Foundation

protocol MovieListViewModelProtocol: ObservableObject {
    var movies: [MediaItem] {get}
}

class MovieListViewModel: MovieListViewModelProtocol, ErrorPresentable {
    @Published var movies: [MediaItem] = []
    @Published var alertModel: AlertModel? = nil
    @Published var isLoading: Bool = false
    
    var actualPage: Int = 0
    var totalPages: Int = 500
    
    let genreIdSubject = PassthroughSubject<Int, Never>()
    
    let refreshSubject = CurrentValueSubject<Void, Never>(())
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var repository: MovieRepository
    
    init(){
        let refreshPublisher = refreshSubject
            .handleEvents(receiveOutput: { [weak self]_ in
                self?.movies = []
                self?.actualPage = 0
            })
        
        Publishers.CombineLatest(genreIdSubject, refreshPublisher)
            .filter { [weak self]_ in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.actualPage < self.totalPages
            }
            .handleEvents(receiveOutput: { [weak self]_ in
                self?.isLoading = true
                self?.actualPage += 1
            })
            .flatMap{ [weak self] (genreId, _) -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchMediaListRequest(genreId: genreId, includeAdult: true, page: actualPage)
                return self.repository.fetchMovies(req: request)
            }
            .delay(for: .seconds(2), scheduler: RunLoop.main)
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                    self?.isLoading = false
                }
            } receiveValue: { [weak self] mediaItemPage in
                if mediaItemPage.totalPages < 500 {
                    self?.totalPages = mediaItemPage.totalPages
                }
                self?.movies.append(contentsOf: mediaItemPage.mediaItems)
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}
