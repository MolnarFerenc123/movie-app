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
    var alertModel: AlertModel? { get }
}

protocol GenreSectionViewModel: ObservableObject {
    var genres: [Genre] { get }
    func loadGenres()
    func genresAppeared()
    func loadMediaItems(genreId: Int)
}

class GenreSectionViewModelImpl: GenreSectionViewModel, ErrorPresentable{
    
    @Published var genres: [Genre] = []
    @Published var alertModel: AlertModel? = nil
    @Published var mediaItemsByGenre: [Int: [MediaItem]] = [:]
    @Published var motdMovieDetail: MediaItemDetail? = nil
    @Published var motdMovie: MediaItem? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private var motdMovieSubject = PassthroughSubject<MediaItem, Never>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    init() {
        useCase.showAppearPopup
            .compactMap { showAppearPopup -> AlertModel? in
                if showAppearPopup {
                    return AlertModel(title: "[[Értékeld az appot]]", message: "[[Értékeld az appot]]", dismissButtonTitle: "[[Rendber]]")
                }
                return nil
            }
            .sink { [weak self]alertModel in
                self?.alertModel = alertModel
            }
            .store(in: &cancellables)
        
        motdMovieSubject
            .flatMap { [weak self]mediaItem in
                guard let self = self else {
                    preconditionFailure("There is no self")
                }
                return self.useCase.getMediaItemDetail(movieId: mediaItem.id)
            }
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { movieDetail in
                self.motdMovieDetail = movieDetail
            }
            .store(in: &cancellables)
    }
    func loadGenres() {
        useCase.loadGenres()
            .sink { completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { genres in
                self.genres = genres
            }
            .store(in: &cancellables)
    }
    
    func loadMediaItems(genreId: Int) {
        useCase.loadMediaItems(genreId: genreId)
            .delay(for: .seconds(3), scheduler: RunLoop.main)
            .map( { mediaItemPage in
                Array(mediaItemPage.mediaItems.prefix(5))
            })
            .sink{ completion in
                if case let .failure(error) = completion {
                    self.alertModel = self.toAlertModel(error)
                }
            } receiveValue: { mediaItems in
                self.mediaItemsByGenre[genreId] = mediaItems
                
                let motdMovie = mediaItems.randomElement()
                
                self.motdMovieSubject.send(motdMovie ?? MediaItem())
            }
            .store(in: &cancellables)
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItemsByGenre(_ genre: Int) -> [MediaItem] {
        return self.mediaItemsByGenre[genre] ?? Array(repeating: MediaItem(), count: 5)
    }
}
