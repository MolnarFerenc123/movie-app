//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import InjectPropertyWrapper
import Foundation

protocol ErrorViewModelProtocol {
    var alertModel: AlertModel {get}
}

protocol GenreSectionViewModelProtocol : ObservableObject {
    
}

class GenreSectionViewModel: GenreSectionViewModelProtocol {
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    
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
        } catch let error as MovieError{
            DispatchQueue.main.async {
                self.alertModel = self.toAlertModel(error)
            }
        }catch {
            print("Error fetchin genres: \(genres)")
        }
    }
    
    private func toAlertModel(_ error: MovieError) -> AlertModel{
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
