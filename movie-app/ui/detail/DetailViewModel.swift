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
    @Published var reviews: [MediaItemReview] = []
    @Published var similarMediaItems: [MediaItem] = []
    @Published var isLoading: Bool = false
    
    var actualPage: Int = 0
    var totalPages: Int = 500
    
    private var cancellables = Set<AnyCancellable>()
    
    let mediaIdSubject = PassthroughSubject<MediaItem, Never>()
    let similarMediasSubject = PassthroughSubject<MediaItem, Never>()
    let favoriteButtonTapped = PassthroughSubject<Void, Never>()
    let refreshSubject = CurrentValueSubject<Void, Never>(())
    
    @Inject
    private var repository: MovieRepository
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    init() {
        let movieDetailsPublisher = mediaIdSubject
            .flatMap{ [weak self]mediaItem -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItem.id)
                isFavorite = store.isMediaItemStored(withId: mediaItem.id)
                switch mediaItem.showType {
                case .movie:
                    return self.repository.fetchMovieDetail(req: request)
                case .tv:
                    return self.repository.fetchTVDetail(req: request)
                case .unknown:
                    return Just<MediaItemDetail>(MediaItemDetail())
                        .setFailureType(to: MovieError.self)
                        .eraseToAnyPublisher()
                }
            }
            .share()
        
        let castPublisher = mediaIdSubject
            .flatMap{ [weak self]mediaItem -> AnyPublisher<[Contributor], MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                if Environments.name == .dev {
                    let request = FetchDetailRequest(mediaId: mediaItem.id)
                    return self.repository.fetchCast(req: request)
                }
                return Just<[Contributor]>([])
                    .setFailureType(to: MovieError.self)
                    .eraseToAnyPublisher()
            }
            .share()
        
        let reviews = mediaIdSubject
                    .flatMap { [weak self]mediaItem in
                        guard let self = self else {
                            preconditionFailure("There is no self")
                        }
                        let request = FetchMovieReviewsRequest(mediaId: mediaItem.id)
                        return self.repository.fetchMovieReviews(req: request)
                    }
        
        Publishers.CombineLatest3(movieDetailsPublisher, castPublisher, reviews)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] (detail, cast, reviews) in
                guard let self = self else { return }
                self.mediaItemDetail = detail
                self.cast = cast
                self.reviews = reviews.prefix(4).map { $0 }
            })
            .store(in: &cancellables)
        
        favoriteButtonTapped
            .flatMap { [weak self] _ -> AnyPublisher<(ModifyMediaResult, Bool), MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let isFavorite = !self.isFavorite
                let request = EditFavoriteRequest(movieId: self.mediaItemDetail.id, favorite: isFavorite)
                return repository.editFavoriteMovie(req: request)
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
        
        let refreshPublisher = refreshSubject
            .handleEvents(receiveOutput: { [weak self]_ in
                self?.similarMediaItems = []
                self?.actualPage = 0
            })
        
        Publishers.CombineLatest(similarMediasSubject, refreshPublisher)
            .filter { [weak self] (mediaItem, _) in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.actualPage < self.totalPages && mediaItem.showType == .movie
            }
            .handleEvents(receiveOutput: { [weak self]_ in
                self?.isLoading = true
                self?.actualPage += 1
            })
            .flatMap{ [weak self] (mediaItem, _) -> AnyPublisher<MediaItemPage, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchSimilarMedias(movieId: mediaItem.id, page: actualPage)
                return self.repository.fetchSimilarMedias(req: request)
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
                self?.similarMediaItems.append(contentsOf: mediaItemPage.mediaItems)
                self?.isLoading = false
            }
            .store(in: &cancellables)
        
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    
}

