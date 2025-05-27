//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import InjectPropertyWrapper
import Foundation
import Combine

protocol GenreSectionViewModelProtocol : ObservableObject {
    var genres: [Genre] {get}
}

class GenreSectionViewModel: GenreSectionViewModelProtocol, ErrorPresentable{
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    
    @Inject
    private var repository: MovieRepository
    
    init() {
        let request = FetchGenreRequest()
        
        let genres = Environments.name == .tv ?
        self.repository.fetchGenres(req: request) :
        self.repository.fetchTVGenres(req: request)
        
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
