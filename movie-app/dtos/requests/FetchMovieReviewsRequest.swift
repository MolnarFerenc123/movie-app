//
//  FetchMovieReviewsRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 24..
//

import Foundation

struct FetchMovieReviewsRequest{
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    
    func asRequestParams() -> [String: Any]{
        return ["language" : Bundle.getLangCode()]
    }
} 
