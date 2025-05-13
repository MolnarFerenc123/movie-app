//
//  MoviePageResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

struct MovieDetailResponse: Decodable {
    let id: Int
    let title: String
    let releaseDate: String?
    let posterPath: String?
    let voteAverage: Double?
    let voteCount: Int?
    let popularity: Double
    let adult: Bool
    let genres: [GenreResponse]
    let spokenLanguages: [SpokenLanguagesResponse]
    let runtime: Int
    let overview: String
    let productionCompanies: [CompanyResponse]

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case popularity
        case adult
        case genres
        case runtime
        case spokenLanguages = "spoken_languages"
        case overview
        case productionCompanies = "production_companies"
    }
    
    
}
