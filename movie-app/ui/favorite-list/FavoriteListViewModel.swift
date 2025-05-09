//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation
import Combine

protocol FavoriteListViewModelProtocol : ObservableObject {
    
}

class FavoriteListViewModel: FavoriteListViewModelProtocol, ErrorPresentable {
    @Published var movies: [Movie] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var service: ReactiveMoviesServiceProtocol
    
    init() {
        let request = FetchFavoritesRequest()
        service.fetchFavorites(req: request)
            .receive(on: RunLoop.main)
            .sink{ completion in
                switch completion {
                case .failure(let error):
                    break
                case .finished:
                    break
                }
            }receiveValue: { [weak self] movies in
                self?.movies = movies
            }
            .store(in: &cancellables)
        
    }
}

//    func loadFavorites() async {
//        do {
//            let request = FetchFavoritesRequest()
//            let movies = try await movieService.fetchFavorites(req: request)
//
//            DispatchQueue.main.async {
//                self.movies = movies
//            }
//        } catch {
//            print("Error fetchin genres: \(movies)")
//        }
//    }
//}
