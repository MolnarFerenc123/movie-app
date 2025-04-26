//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation

struct AddFavoriteRequest {
    let accessToken: String = Config.bearerToken
    let accountId: String = Config.accountId
    let movieId: Int
    func asReqestParams() -> [String: String] {
        return ["language" : Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "en"]
    }
    func asBodyParams() -> [String: Any] {
        return ["media_type" : "movie",
                "media_id" : movieId,
                "favorite" : true]
    }
}
