//
//  FetchDetailRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//
import Foundation

struct FetchDetailRequest {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asReqestParams() -> [String: String] {
        return ["language" : Locale.preferredLanguages.first?.components(separatedBy: "-")[0] ?? "en"]
    }
}
