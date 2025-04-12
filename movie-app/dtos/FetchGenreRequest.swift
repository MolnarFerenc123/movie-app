//
//  FetchGenreRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

struct FetchGenreRequest {
    let accessToken: String = "Config.bearerToken"
    
    func asReqestParams() -> [String: String] {
        return [:]
    }
}
