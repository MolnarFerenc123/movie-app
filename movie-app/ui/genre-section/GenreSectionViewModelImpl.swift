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
    @Published var motdMovieDetail: MediaItemDetail = MediaItemDetail()
    @Published var motdMovie: MediaItem? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private var motdMovieSubject = PassthroughSubject<MediaItem, Never>()
    
    @Inject
    private var useCase: GenreSectionUseCase
    
    @Inject
    private var mediaItemStore: MediaItemStoreProtocol
    
    var allGenresLoaded: Bool {
        genres.allSatisfy { genre in
            mediaItemsByGenre[genre.id] != nil
        }
    }
    
    var motdMediaItemLoaded: Bool = false
    
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
                return self.useCase.getMediaItemDetail(mediaItem: mediaItem)
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
                for genre in genres {
                    self.loadMediaItems(genreId: genre.id)
                }
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
                if self.allGenresLoaded && !self.motdMediaItemLoaded {
                    self.getMotdMovie()
                }
            }
            .store(in: &cancellables)
    }
    
    func getMotdMovie(){
        let motdMovie = mediaItemsByGenre.randomElement()?.value.randomElement()
        self.motdMovieSubject.send(motdMovie ?? MediaItem())
        self.motdMediaItemLoaded = true
    }
    
    func genresAppeared() {
        useCase.genresAppeared()
    }
    
    func getMediaItemsByGenre(_ genre: Int) -> [MediaItem] {
        return self.mediaItemsByGenre[genre] ?? Array(repeating: MediaItem(), count: 5)
    }
}
