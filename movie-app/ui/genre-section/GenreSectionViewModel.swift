//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import InjectPropertyWrapper
import Foundation
import Combine

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel {get}
}

protocol GenreSectionViewModelProtocol : ObservableObject {
    var genres: [Genre] {get}
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPresentable{
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    
    @Inject
    private var reactiveMovieService: ReactiveMoviesService
    
    init() {
        let request = FetchGenreRequest()
        
        let genres = Enviroments.name == .tv ?
        self.reactiveMovieService.fetchGenres(req: request) :
        self.reactiveMovieService.fetchTvSeriesGenres(req: request)
        
        genres
            .handleEvents(receiveOutput: { genres in
                print("Custom action before receive: genres count = \(genres.count)")
            })
            .print("<<<debug")
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
}
