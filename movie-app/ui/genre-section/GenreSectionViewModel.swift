//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

protocol GenreSectionViewModelProtocol : ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    
    @Inject
    private var movieService: MovieServiceProtocol
    
    func loadGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Enviroments.name == .tv ? try await movieService.fetchTvSeriesGenres(req: request) :
                                                    try await movieService.fetchGenres(req: request)
            
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetchin genres: \(genres)")
        }
    }
}
