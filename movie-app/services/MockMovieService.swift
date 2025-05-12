//
//  MovieServiceProtocol.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation
import Combine

class MockMoviesService: MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        Just([])
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        Just([])
            .setFailureType(to: MovieError.self)
            .eraseToAnyPublisher()
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem] {
        return [
            MediaItem(id: 1,
                      title: "Mock movie1",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000
                     ),
            MediaItem(id: 2,
                      title: "Mock movie2",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000
                     ),
            MediaItem(id: 3,
                      title: "Mock movie3",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000
                     ),
            MediaItem(id: 4,
                      title: "Mock movie4",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000
                     ),
            MediaItem(id: 5,
                      title: "Mock movie5",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000
                     )
            
        ]
    }
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return [
            Genre(id: 0, name: "Action"),
            Genre(id: 1, name: "Sci-fi"),
            Genre(id: 2, name: "Fantasy"),
            Genre(id: 3, name: "Horror"),
            
        ]
    }
    
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem] {
        return [
            MediaItem(id: 1,
                      title: "Mock movie1",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000),
            MediaItem(id: 2,
                      title: "Mock movie2",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000),
            MediaItem(id: 3,
                      title: "Mock movie3",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000),
            MediaItem(id: 4,
                      title: "Mock movie4",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000),
            MediaItem(id: 5,
                      title: "Mock movie5",
                      year: "2024",
                      duration: "1h 34m",
                      imageUrl: nil,
                      rating: 1.0,
                      voteCount: 1000),
            
        ]
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return []
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest) async throws -> [MediaItem] {
        []
    }
    
    
    func editFavoriteMovie(req: EditFavoriteRequest) async throws -> AddFavoriteResponse {
        AddFavoriteResponse(success: true,
                            statusCode: 100,
                            statusMessage: ""
        )
    }
    
}
