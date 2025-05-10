//
//  TVResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 09..
//

struct TVPageResponse: Decodable {
    let page: Int
    let results: [TVResponse]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct TVResponse: Decodable {
    let id: Int
    let name: String
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
    }
    
}
