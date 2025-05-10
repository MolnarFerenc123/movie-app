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
    case fetchTVGenres(req: FetchGenreRequest)
    case fetchMovies(req: FetchMediaListRequest)
    case fetchTV(req: FetchMediaListRequest)
    case searchMovies(req: SearchMovieRequest)
    case fetchFavoriteMovies(req: FetchFavoriteMovieRequest)
    case addFavoriteMovie(req: AddFavoriteRequest)
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
        case .fetchTVGenres:
            return "genre/tv/list"
        case .fetchMovies:
            return "discover/movie"
        case .searchMovies:
            return "search/movie"
        case .fetchFavoriteMovies(let req):
            return "account/\(req.accountId)/favorite/movies"
        case .addFavoriteMovie(let req):
            return "account/\(req.accountId)/favorite"
        case .fetchTV:
            return "discover/tv"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .fetchFavoriteMovies:
            return .get
        case .addFavoriteMovie:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .fetchGenres(let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .fetchTVGenres(let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .fetchMovies(let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .searchMovies(let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .fetchFavoriteMovies(let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .addFavoriteMovie(let req):
            return .requestCompositeParameters(
                bodyParameters: req.asBodyParams(),
                bodyEncoding: JSONEncoding.default,
                urlParameters: req.asReqestParams())
        case .fetchTV(req: let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case let .fetchGenres(req):
            return ["Authorization" : req.accessToken]
        case let .fetchTVGenres(req):
            return ["Authorization" : req.accessToken]
        case let .fetchMovies(req):
            return ["Authorization" : req.accessToken]
        case let .fetchTV(req):
            return ["Authorization" : req.accessToken]
        case let .searchMovies(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchFavoriteMovies(req):
            return ["Authorization" : req.accessToken]
        case let .addFavoriteMovie(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]

        }
    }
    
    
}
