//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation

struct EditFavoriteBodyRequest : Encodable {
    let movieId: Int
    let favorite: Bool
    let mediaType = "movie"
    
    enum CodingKeys: String, CodingKey {
        case favorite = "favorite"
        case movieId = "media_id"
        case mediaType = "media_type"
    }
}


struct EditFavoriteRequest : Encodable {
    let accessToken: String = Config.bearerToken
    let accountId: String = Config.accountId
    let movieId: Int
    let favorite: Bool
    func asReqestParams() -> [String: Any] {
        return ["language" : Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "en",
                "media_type" : "movie",
                        "media_id" : movieId,
                        "favorite" : favorite]
    }
}
