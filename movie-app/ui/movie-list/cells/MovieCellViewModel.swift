//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import Combine
import InjectPropertyWrapper

protocol MovieCellViewModelProtocol : ObservableObject {
    var addFavoriteResponse: EditFavoriteResponse? {get}
}

class MovieCellViewModel: MovieCellViewModelProtocol, ErrorPresentable {
    @Published var addFavoriteResponse: EditFavoriteResponse? = nil
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var alertModel: AlertModel? = nil
    @Published var isFavorite: Bool = false
    
    let favoriteButtonTapped = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    init() {
        favoriteButtonTapped
                    .flatMap { [weak self] mediaItemId -> AnyPublisher<(EditFavoriteResult, Bool), MovieError> in
                        guard let self = self else {
                            preconditionFailure("There is no self")
                        }
                        let isFavorite = !self.isFavorite
                        let request = EditFavoriteRequest(movieId: mediaItemId, favorite: isFavorite)
                        return service.editFavoriteMovie(req: request)
                            .map { result in
                            (result, isFavorite)
                        }
                        .eraseToAnyPublisher()
                    }
                    .sink { [weak self] completion in
                        if case let .failure(error) = completion {
                            self?.alertModel = self?.toAlertModel(error)
                        }
                    } receiveValue: { [weak self] result, isFavorite in
                        guard let self = self else {
                            preconditionFailure("There is no self")
                        }
                        if result.success {
                            self.isFavorite = isFavorite
                            if isFavorite {
                                //self.favoriteMediaStore.addFavoriteMediaItem(self.mediaItemDetail)
                            } else {
                                self.store.deleteMediaItem(withId: self.mediaItemDetail.id)
                            }
                        }
                    }
                    .store(in: &cancellables)
        
    }
}
