//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import Combine
import InjectPropertyWrapper

protocol MovieCellViewModelProtocol : ObservableObject {
    var addFavoriteResponse: AddFavoriteResponse? {get}
}

class MovieCellViewModel: MovieCellViewModelProtocol, ErrorPresentable {
    @Published var addFavoriteResponse: AddFavoriteResponse? = nil
    @Published var alertModel: AlertModel? = nil
    
    let mediaIdSubject = PassthroughSubject<[Any], Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaIdSubject
            .flatMap{ [weak self]mediaItemId -> AnyPublisher<AddFavoriteResponse, MovieError> in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = EditFavoriteRequest(movieId: mediaItemId[0] as! Int, favorite: mediaItemId[1] as! Bool)
                if mediaItemId[1] as! Bool {
                    if !Favorites.favoritesId.contains(mediaItemId[0] as! Int) {
                        Favorites.favoritesId.append(mediaItemId[0] as! Int)
                    }
                }else{
                    if Favorites.favoritesId.contains(mediaItemId[0] as! Int) {
                        Favorites.favoritesId = Favorites.favoritesId.filter{$0 != mediaItemId[0] as! Int}
                    }
                }
                
                return self.service.editFavoriteMovie(req: request)
            }
            .sink { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.alertModel = self?.toAlertModel(error)
                }
            } receiveValue: { [weak self] addFavoriteResponse in
                self?.addFavoriteResponse = addFavoriteResponse
            }
            .store(in: &cancellables)
        
    }
}
