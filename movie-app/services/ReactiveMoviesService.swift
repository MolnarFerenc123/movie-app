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
import Alamofire

protocol ReactiveMoviesServiceProtocol {
    func fetchGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func fetchTVGenres(req: FetchGenreRequest) -> AnyPublisher<[Genre], MovieError>
    func searchMovies(req: SearchMovieRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchMovies(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchTV(req: FetchMediaListRequest) -> AnyPublisher<[MediaItem], MovieError>
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool) -> AnyPublisher<[MediaItem], MovieError>
    func editFavoriteMovie(req: EditFavoriteRequest) -> AnyPublisher<EditFavoriteResult, MovieError>
    func fetchMovieDetail(req: FetchDetailRequest) -> AnyPublisher<MediaItemDetail, MovieError>
    func fetchCast(req: FetchDetailRequest) -> AnyPublisher<[Contributor], MovieError>
}

class ReactiveMoviesService: ReactiveMoviesServiceProtocol {
    
    @Inject
    private var store: MediaItemStoreProtocol
    
    @Inject
    var moya: MoyaProvider<MultiTarget>!
    
    @Inject
    var networkMonitor: NetworkMonitorProtocol
    
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
    
    func fetchFavoriteMovies(req: FetchFavoriteMovieRequest, fromLocal: Bool = false) -> AnyPublisher<[MediaItem], MovieError> {
            
            let serviceResponse: AnyPublisher<[MediaItem], MovieError> = self.requestAndTransform(
                target: MultiTarget(MoviesApi.fetchFavoriteMovies(req: req)),
                decodeTo: MoviePageResponse.self,
                transform: { $0.results.map(MediaItem.init(dto:)) }
            )
            .handleEvents(receiveOutput: { [weak self]mediaItems in
                self?.store.saveMediaItems(mediaItems)
            })
            .eraseToAnyPublisher()
            
            let localResponse: AnyPublisher<[MediaItem], MovieError> = store.mediaItems
            
            return networkMonitor.isConnected
                .flatMap { isConnected -> AnyPublisher<[MediaItem], MovieError> in
                    if isConnected {
                        return serviceResponse
                    } else {
                        return localResponse
                    }
                }
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
            case .failure(let error):
                if error.isNoInternetError {
                    future(.failure(.noInternetError))
                }else {
                    future(.failure(.unexpectedError))
                }
                
            }
        }
    }
    return future
        .eraseToAnyPublisher()
}
}

extension MoyaError {
    var isNoInternetError: Bool {
        if case let .underlying(error, _) = self {
            // Ha AFError
            if let afError = error as? AFError {
                if let urlError = afError.underlyingError as? URLError {
                    return urlError.code == .notConnectedToInternet
                } else if let nsError = afError.underlyingError as NSError? {
                    return nsError.domain == NSURLErrorDomain && nsError.code == NSURLErrorNotConnectedToInternet
                }
            }
        }
        return false
    }
}
