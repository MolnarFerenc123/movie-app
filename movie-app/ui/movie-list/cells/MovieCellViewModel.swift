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
    let addFavorite = PassthroughSubject<Int, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init(){
        addFavorite
    }
}
