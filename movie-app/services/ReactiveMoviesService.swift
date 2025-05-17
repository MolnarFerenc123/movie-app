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
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchCast(req: FetchDetailRequest) -> AnyPublisher<[Contributor], MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTVGenres(req: req)),
            decodeTo: GenreListResponse.self,
            transform: { $0.genres.map(Genre.init(dto:)) }
        )
    }
    
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.searchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchTV(req: req)),
            decodeTo: TVPageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
    }
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest) -> AnyPublisher<[MediaItem], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
            decodeTo: MoviePageResponse.self,
            transform: { $0.results.map(MediaItem.init(dto:)) }
        )
            .handleEvents(receiveOutput: { mediaItems in
                self.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
    }
    
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.editFavoriteMovie(req: req)),
            decodeTo: EditFavoriteResponse.self,
            transform: { response in
                EditFavoriteResult(dto: response)
            }
        )
    }
    
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchMovieDetail(req: req)),
            decodeTo: MovieDetailResponse.self,
            transform: { MediaItemDetail(dto: $0) }
        )
        
    }
    
    
    func fetchCast(req: FetchDetailRequest) -> AnyPublisher<[Contributor], MovieError> {
        requestAndTransform(
            target: MultiTarget(MoviesApi.fetchCast(req: req)),
            decodeTo: ContributorListResponse.self,
            transform: { $0.contributors.map(Contributor.init(dto:)) }
        )
    }
    
    
    private func requestAndTransform<ResponseType: Decodable, Output>(
        target: MultiTarget,
        decodeTo: ResponseType.Type,
        transform: @escaping (ResponseType) -> Output
    ) -> AnyPublisher<Output, MovieError> {
        let future = Future<Output, MovieError> { future in
            self.moya.request(target) { result in
                switch result {
                case .success(let response):
                    switch response.statusCode {
                    case 200..<300:
                        do {
                            let decoded = try JSONDecoder().decode(decodeTo, from: response.data)
                            let output = transform(decoded)
                            future(.success(output))
                        } catch {
                            future(.failure(MovieError.unexpectedError))
                        }
                    case 400..<500:
                        future(.failure(MovieError.clientError))
                    default:
                        if let apiError = try? JSONDecoder().decode(MovieAPIErrorResponse.self, from: response.data) {
                            if apiError.statusCode == 7 {
                                future(.failure(.invalidApiKeyError(message: apiError.statusMessage)))
                            } else {
                                future(.failure(.unexpectedError))
                            }
                        } else {
                            future(.failure(.unexpectedError))
                        }
                    }
                case .failure:
                    future(.failure(.unexpectedError))
                }
            }
        }
        return future
            .eraseToAnyPublisher()
    }
}
