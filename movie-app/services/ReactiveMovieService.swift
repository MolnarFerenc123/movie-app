//
//  ReactiveMovieService.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 06..
//

import Foundation
import Moya
import InjectPropertyWrapper
import Combine

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTvSeriesGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError>
    func fetchFavorites(req: FetchFavoritesRequest) -> AnyPublisher<[Movie], MovieError>
    func addFavorite(req: AddFavoriteRequest) -> AnyPublisher<AddFavoriteResponse, MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    func fetchMovies(req: FetchMoviesRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func fetchFavorites(req: FetchFavoritesRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavorites(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    func addFavorite(req: AddFavoriteRequest) -> AnyPublisher<AddFavoriteResponse, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.addFavorite(req: req)),
            decodeTo: AddFavoriteResponse.self,
            transform: { response in
                response
            }
        )
    }
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTvSeriesGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTvSeriesGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchMoviesByTitle(req: FetchMoviesByTitleRequest) -> AnyPublisher<[Movie], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMoviesByTitle(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(Movie.init(dto:)) }
        )
    }
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { promise in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            promise(.success(output))
                        } catch {
                            promise(.failure(.unexpectedError))
                        }
                    case 400..<500:
                        promise(.failure(.resourceNotFound))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                promise(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                promise(.failure(.unexpectedError))
                            }
                        } else {
                            promise(.failure(.unexpectedError))
                        }
                    }
                case .failure:
                    promise(.failure(.unexpectedError))
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}
