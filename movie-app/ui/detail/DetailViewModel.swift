//
//  DetailViewModel.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//
import Foundation
import Combine
import InjectPropertyWrapper

protocol DetailViewModelProtocol: ObservableObject {
}


class DetailViewModel: DetailViewModelProtocol, ErrorPresentable{
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var cast: [Contributor] = []
    @Published var isFavorite: Bool = false
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    init() {
        let movieDetailsPublisher = mediaIdSubject
            .flatMap{ [weak self]mediaItemId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                isFavorite = store.isMediaItemStored(withId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
            .share()
        
        let castPublisher = mediaIdSubject
            .flatMap{ [weak self]mediaItemId -> AnyPublisher<[Contributor], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchCast(req: request)
            }
            .share()
        
        Publishers.CombineLatest(movieDetailsPublisher, castPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (detail, cast) in
                guard let self = self else { return }
                self.mediaItemDetail = detail
                self.cast = cast
            })
            .store(in: &cancellables)
        
        favoriteButtonTapped
                    .flatMap { [weak self] _ -> AnyPublisher<(EditFavoriteResult, Bool), MovieError> in
                        guard let self = self else {
                            preconditionFailure("There is no self")
                        }
                        let isFavorite = !self.isFavorite
                        let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, favorite: isFavorite)
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
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    
}

