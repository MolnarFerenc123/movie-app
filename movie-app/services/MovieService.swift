//
//  MovieService.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation
import InjectPropertyWrapper
import Moya

protocol MovieServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTvSeriesGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie]
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) async throws -> [Movie]
}

class MovieService : MovieServiceProtocol {
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
                    moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                        switch result {
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                                let genres = decodedResponse.genres.map{ genreResponse in
                                    Genre(dto: genreResponse)
                                }
                                    .sorted {
                                        $0.name < $1.name
                                    }
                                continuation.resume(returning: genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
    
    func fetchTvSeriesGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
                    moya.request(MultiTarget(MoviesApi.fetchTvSeriesGenres(req: req))) { result in
                        switch result {
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreListResponse.self, from: response.data)
                                let genres = decodedResponse.genres.map{ genreResponse in
                                    Genre(dto: genreResponse)
                                }
                                continuation.resume(returning: genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
            return try await withCheckedThrowingContinuation { continuation in
                moya.request(MultiTarget(MoviesApi.fetchMovies(req: req))) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResponse = try JSONDecoder().decode(MoviePageResponse.self, from: response.data)
                            let movies = decodedResponse.results.map { Movie(dto: $0) }
                            continuation.resume(returning: movies)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) async throws -> [Movie] {
            return try await withCheckedThrowingContinuation { continuation in
                moya.request(MultiTarget(MoviesApi.fetchMoviesByTitle(req: req))) { result in
                    switch result {
                    case .success(let response):
                        do {
                            let decodedResponse = try JSONDecoder().decode(MoviePageResponse.self, from: response.data)
                            let movies = decodedResponse.results.map { Movie(dto: $0) }
                            continuation.resume(returning: movies)
                        } catch {
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
}
