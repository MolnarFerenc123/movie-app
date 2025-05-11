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
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaIdSubject
            .flatMap{ [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = FetchDetailRequest(mediaId: mediaItemId)
                return self.service.fetchMovieDetail(req: request)
            }
            .receive(on: RunLoop.main)
            .sink{ [weak self]completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            }receiveValue: { [weak self]mediaItemDetail in
                self?.mediaItemDetail = mediaItemDetail
            }
            .store(in: &cancellables)
        
    }
}
