//
//  ContributorDetail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 14..
//

import Foundation

struct CastDetailResponse: Codable, Identifiable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography: String
    let birthday: String?
    let deathday: String?
    let gender: Int
    let homepage: String?
    let id: Int
    let imdbID: String
    let knownForDepartment: String
    let name: String
    let placeOfBirth: String?
    let popularity: Double
    let profilePath: String?
    
    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography
        case birthday
        case deathday
        case gender
        case homepage
        case id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
    
    var profileImageURL: URL? {
        guard let profilePath = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(profilePath)")
    }
}
