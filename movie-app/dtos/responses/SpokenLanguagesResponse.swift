//
//  SpokenLanguagesResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

struct SpokenLanguagesResponse: Decodable {
    let englishName: String
    let iso639: String
    let name: String

    enum CodingKeys: String, CodingKey {
        case englishName = "english_name"
        case iso639 = "iso_639_1"
        case name
    }
}
