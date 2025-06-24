//
//  FetchMoviesRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Foundation

struct FetchContributorDetailRequest {
    let accessToken: String = Config.bearerToken
    let contributorId: Int
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Bundle.getLangCode()]
    }
}
