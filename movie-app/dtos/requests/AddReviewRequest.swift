//
//  AddReviewRequest.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 24..
//

import Foundation

struct AddReviewBodyRequest: Encodable{
    let mediaId: Int
    let rating: Double
    
    enum CodingKeys: String, CodingKey{
        case mediaId = "movie_id"
        case rating = "value"
    }
}

struct AddReviewRequest: Encodable {
    let accessToken: String = Config.bearerToken
    let mediaId: Int
    let rating: Double
    
    func asReqestParams() -> [String: Any] {
        return ["language" : Bundle.getLangCode(),
                        "movie_id" : mediaId,
                        "value" : rating]
    }
}
