//
//  MovieService.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation
import InjectPropertyWrapper
import Moya

struct MovieAPIErrorResponse: Decodable {
    let success : Bool
    let statusCode : Int
    let statusMessage : String
    
    enum CodingKeys: String, CodingKey {
        case success
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

protocol MovieServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTvSeriesGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie]
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) async throws -> [Movie]
    func fetchFavorites(req: FetchFavoritesRequest) async throws -> [Movie]
    func addFavorite(req: AddFavoriteRequest) async throws -> AddFavoriteResult
}

class MovieService : MovieServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTvSeriesGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTvSeriesGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMoviesRequest) async throws -> [Movie] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) async throws -> [Movie] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMoviesByTitle(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(Movie.init(dto:))
            }
        )
    }
    
    func fetchFavorites(req: FetchFavoritesRequest) async throws -> [Movie] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavorites(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(Movie.init(dto:))
            }
        )
    }
    
    func addFavorite(req: AddFavoriteRequest) async throws -> AddFavoriteResult{
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.addFavorite(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(AddFavoriteResponse.self, from: response.data)
                        let result = AddFavoriteResult(dto: decodedResponse)
                        continuation.resume(returning: result)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) async throws -> Output {
        try await withCheckedThrowingContinuation { continuation in
            moya.request(target) { result in
                switch result {
                case .success(let response):
                    
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            // Ha nincs logikai hiba, dekódoljuk a választ
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            continuation.resume(returning: output)
                        } catch {
                            continuation.resume(throwing: MovieError.unexpectedError)
                        }
                    case 400..<500:
                        continuation.resume(throwing: MovieError.resourceNotFound)
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                continuation.resume(throwing: MovieError.invalidApiKeyError(message: apiError.statusMessage))
                            } else {
                                continuation.resume(throwing: MovieError.unexpectedError)
                            }
                            return
                        }
                    }

                case .failure:
                    continuation.resume(throwing: MovieError.unexpectedError)
                }
            }
        }
    }
    
    
    
}
