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

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    @Inject
    private var movieService: MovieServiceProtocol
    
    init(){
        let request = FetchGenreRequest()
        
        let future = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchGenres(req: request)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        let futureTv = Future<[Genre], Error> { future in
            Task {
                do {
                    let genres = try await self.movieService.fetchTvSeriesGenres(req: request)
                    future(.success(genres))
                } catch {
                    future(.failure(error))
                }
            }
        }
        
        
//        Publishers.CombineLatest(future, futureTv)
        future
            .flatMap({ genres in
                futureTv.map { genreTv in
                    (genres, genreTv)
                }
            })
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.alertModel = self.toAlertModel(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self]genres, genresTv in
                self?.genres = genres + genresTv
            }
            .store(in: &cancellables)
    }

    func loadGenres() async {
        do {
            let request = FetchGenreRequest()
            let genres = Enviroments.name == .tv ? try await movieService.fetchTvSeriesGenres(req: request) :
                                                    try await movieService.fetchGenres(req: request)
            
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch let error as MovieError{
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        }catch {
            print("Error fetchin genres: \(genres)")
        }
    }
    
    private func toAlertModel(_ error: Error) -> AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(title: "unexpected.error.title", message: "unexpected.error.message", dismissButtonTitle: "button.close.text")
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(title: "API Error", message: message, dismissButtonTitle: "button.close.text")
        case .resourceNotFound:
            return AlertModel(title: "resource.not.found.error.title", message: "resource.not.found.error.message", dismissButtonTitle: "button.close.text")
        default:
            return AlertModel(title: "unexpected.error.title", message: "unexpected.error.message", dismissButtonTitle: "button.close.text")
        }
    }
}
