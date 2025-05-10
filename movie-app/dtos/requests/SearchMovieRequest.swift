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
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "en",
                "query" : query]
    }
}
