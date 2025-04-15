//
//  MoviePageResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

struct MoviePageResponse: Decodable {
    let page: Int
    let results: [MovieResponse]
    let totalPages: Int
    let totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct MovieResponse: Decodable {
    let id: Int
    let title: String
    let releaseDate: String
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
    }
}
