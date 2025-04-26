//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import SwiftUI
import InjectPropertyWrapper

protocol MovieCellViewModelProtocol : ObservableObject {
    
}

class MovieCellViewModel: MovieCellViewModelProtocol {
    @Inject
    private var movieService: MovieServiceProtocol

    func addFavorite(movieId : Int) async {
        do {
            let request = AddFavoriteRequest(movieId: movieId)
            try await movieService.addFavorite(req: request)
        }catch{
            print("Error when adding movie to favorite. Movie id: \(movieId)")
        }
        
    }
}
