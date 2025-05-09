//
//  MoviesApi.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation
import Moya

enum MoviesApi {
    case fetchGenres(req: FetchGenreRequest)
    case fetchTvSeriesGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMoviesRequest)
    case fetchMoviesByTitle(req: FetchMoviesByTitleRequest)
    case fetchFavorites(req: FetchFavoritesRequest)
    case addFavorite(req: AddFavoriteRequest)
}

extension MoviesApi: TargetType{
    var baseURL: URL {
        let baseUrl = "https://api.themoviedb.org/3/"
        guard let baseUrl = URL(string: baseUrl) else {
            preconditionFailure("Base url is not a valid url")
        }
        return baseUrl
    }
    
    var path: String {
        switch self {
        case .fetchGenres:
            return "genre/movie/list"
        case .fetchTvSeriesGenres:
            return "genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        case .fetchMoviesByTitle:
            return "search/movie"
        case .fetchFavorites(let req):
            return "account/\(req.accountId)/favorite/movies"
        case .addFavorite(let req):
            return "account/\(req.accountId)/favorite"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTvSeriesGenres, .fetchMovies, .fetchMoviesByTitle, .fetchFavorites:
            return .get
        case .addFavorite:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case let .fetchGenres(req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case let .fetchTvSeriesGenres(req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case let .fetchMovies(req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case let .fetchMoviesByTitle(req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case let .fetchFavorites(req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case let .addFavorite(req):
            return .requestCompositeParameters(
                bodyParameters: req.asBodyParams(),
                bodyEncoding: JSONEncoding.default,
                urlParameters: req.asReqestParams())
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchTvSeriesGenres(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchMovies(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchMoviesByTitle(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchFavorites(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .addFavorite(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]

        }
    }
    
    
}
