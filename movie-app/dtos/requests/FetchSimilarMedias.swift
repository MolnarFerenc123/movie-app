//
//  FetchMoviesRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation

struct FetchSimilarMedias {
    let accessToken: String = Config.bearerToken
    let movieId: Int
    let page: Int
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Bundle.getLangCode(),
                "movie_id" : movieId,
                "page" : page
        ]
    }
}
