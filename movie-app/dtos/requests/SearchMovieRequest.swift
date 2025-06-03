//
//  FetchMoviesRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation

struct SearchMovieRequest {
    let accessToken: String = Config.bearerToken
    let query: String
    let includeAdult: Bool
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Bundle.getLangCode(),
                "query" : query,
                "include_adult" : includeAdult
        ]
    }
}
