//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation

struct FetchGenreRequest {
    let accessToken: String = Config.bearerToken
    func asReqestParams() -> [String: String] {
        return ["language" : Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "en"]
    }
}
