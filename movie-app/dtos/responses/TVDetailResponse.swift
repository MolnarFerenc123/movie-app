//
//  TVDetailResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 28..
//

struct TVDetailResponse: Decodable {
    let id: Int
    let title: String
    let firstAirDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let adult: Bool
    let genres: [GenreResponse]
    let episodeRunTime: [Int]
    let spokenLanguages: [SpokenLanguagesResponse]
    let overview: String
    let productionCompanies: [ContributorResponse]
    let homepage: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title = "name"
        case firstAirDate = "first_air_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case adult
        case genres
        case episodeRunTime = "episode_run_time"
        case spokenLanguages = "spoken_languages"
        case overview
        case productionCompanies = "production_companies"
        case homepage
    }
}
