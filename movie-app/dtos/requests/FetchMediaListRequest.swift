//
//  FetchMoviesRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation

struct FetchMediaListRequest {
    let accessToken: String = Config.bearerToken
    let genreId: Int
    let includeAdult: Bool
    let page: Int
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Bundle.getLangCode(),
                "with_genres" : genreId,
                "include_adult" : includeAdult,
                "page" : page
        ]
    }
}
