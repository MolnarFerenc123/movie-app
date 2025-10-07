//
//  CombinedMediaItemResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 28..
//

struct CombinedMediaItemCastResponse: Decodable{
    let cast: [CombinedMediaItemResponse]

    enum CodingKeys: String, CodingKey{
        case cast
    }
}

struct CombinedMediaItemResponse: Decodable{
    let id: Int
    let originalTitle: String?
    let originalName: String?
    let releaseDate: String?
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double
    let voteCount: Int
    let popularity: Double
    let mediaType: String
    let character: String

    enum CodingKeys: String, CodingKey{
        case id
        case originalTitle = "original_title"
        case originalName = "original_name"
        case firstAirDate = "first_air_date"
        case popularity
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case mediaType = "media_type"
        case character
    }
}
