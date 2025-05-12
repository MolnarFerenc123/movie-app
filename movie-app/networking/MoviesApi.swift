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
    case editFavoriteMovie(req: EditFavoriteRequest)
    case fetchMovieDetail(req: FetchDetailRequest)
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
        case .editFavoriteMovie(let req):
            return "account/\(req.accountId)/favorite"
        case .fetchTV:
            return "discover/tv"
        case .fetchMovieDetail(let req):
            return "movie/\(req.mediaId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .fetchGenres, .fetchTVGenres, .fetchMovies, .fetchTV, .searchMovies, .fetchFavoriteMovies, .fetchMovieDetail:
            return .get
        case .editFavoriteMovie:
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
        case .editFavoriteMovie(let req):
            return .requestCompositeParameters(
                bodyParameters: req.asBodyParams(),
                bodyEncoding: JSONEncoding.default,
                urlParameters: req.asReqestParams())
        case .fetchTV(req: let req):
            return .requestParameters(parameters: req.asReqestParams(), encoding: URLEncoding.queryString)
        case .fetchMovieDetail(req: let req):
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
        case let .editFavoriteMovie(req):
            return ["Authorization" : req.accessToken,
                    "accept" : "application/json"]
        case let .fetchMovieDetail(req):
            return ["Authorization" : req.accessToken]
        }
    }
    
    
}
