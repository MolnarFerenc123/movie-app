//
//  MovieService.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation
import InjectPropertyWrapper
import Moya
import Combine

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

protocol MoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre]
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem]
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem]
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest) async throws -> [MediaItem]
    func editFavoriteMovie(req: EditFavoriteRequest) async throws -> EditFavoriteResponse
}

class MoviesService : MoviesServiceProtocol {
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) async throws -> [Genre] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(MediaItem.init(dto:))
            }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest) async throws -> [MediaItem] {
        try await requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { (moviePageResponse: MoviePageResponse) in
                moviePageResponse.results.map(MediaItem.init(dto:))
            }
        )
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) async throws -> EditFavoriteResponse{
        return try await withCheckedThrowingContinuation { continuation in
            moya.request(MultiTarget(MoviesApi.editFavoriteMovie(req: req))) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedResponse = try JSONDecoder().decode(EditFavoriteResponse.self, from: response.data)
                        continuation.resume(returning: decodedResponse)
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
                        continuation.resume(throwing: MovieError.clientError)
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
