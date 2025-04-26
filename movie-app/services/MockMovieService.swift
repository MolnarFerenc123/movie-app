//
//  MovieServiceProtocol.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation

class MockMoviesService: MovieServiceProtocol {
    func addFavorite(req: AddFavoriteRequest) async throws -> AddFavoriteResult {
        AddFavoriteResult(success: true, statusCode: 2, statusMessage: "Mock")
    }
    
    func fetchFavorites(req: FetchFavoritesRequest) async throws -> [Movie] {
        return [
            Movie(id: 1,
                  title: "Mock movie1",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 2,
                  title: "Mock movie2",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 3,
                  title: "Mock movie3",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 4,
                  title: "Mock movie4",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 5,
                  title: "Mock movie5",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            
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
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
        return [
            Movie(id: 1,
                  title: "Mock movie1",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 2,
                  title: "Mock movie2",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 3,
                  title: "Mock movie3",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 4,
                  title: "Mock movie4",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            Movie(id: 5,
                  title: "Mock movie5",
                  year: "2024",
                  duration: "1h 34m",
                  imageUrl: nil,
                  rating: 1.0,
                  voteCount: 1000,
                  popularity: 15.54),
            
        ]
    }
    
    func fetchTvSeriesGenres(req: FetchGenreRequest) async throws -> [Genre] {
        []
    }
    
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) async throws -> [Movie] {
        []
    }
}
