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
    var mediaItemDetail: MediaItemDetail { get }
    var cast: [Contributor] { get }
    var alertModel: AlertModel? { get set }
    var mediaIdSubject: PassthroughSubject<Int, Never> { get }
}


class DetailViewModel: DetailViewModelProtocol, ErrorPresentable{
    @Published var mediaItemDetail: MediaItemDetail = MediaItemDetail()
    @Published var cast: [Contributor] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let movieDetailsPublisher = mediaIdSubject
            .flatMap{ [weak self]mediaItemId -> AnyPublisher<MediaItemDetail, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
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
        
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
}

