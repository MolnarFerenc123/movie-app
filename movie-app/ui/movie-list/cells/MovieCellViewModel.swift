//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import Combine
import InjectPropertyWrapper

protocol MovieCellViewModelProtocol : ObservableObject {
    
}

class MovieCellViewModel: MovieCellViewModelProtocol {
    
    let mediaIdSubject = PassthroughSubject<Int, Never>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        mediaIdSubject
            .flatMap{ [weak self]mediaItemId in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                let request = AddFavoriteRequest(movieId: mediaItemId)
                return self.service.addFavoriteMovie(req: request)
            }
        
    }
}
