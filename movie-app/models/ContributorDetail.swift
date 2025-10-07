//
//  ContributorDetail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 14..
//
import Foundation

struct ContributorDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let biography: String?
    let originPlace: String?
    let birthYear: String?
    let popularity: Double?
    let imagePath: URL?
    
    init() {
        self.id = 0
        self.name = ""
        self.biography = ""
        self.popularity = 0
        self.imagePath = nil
        self.birthYear = ""
        self.originPlace = ""
    }
    
    init(id: Int, name: String, biography: String, originPlace: String, birthYear: String?, popularity: Double?, imagePath: URL) {
        self.id = id
        self.name = name
        self.biography = biography
        self.originPlace = originPlace
        self.birthYear = birthYear
        self.popularity = popularity
        self.imagePath = imagePath
    }
    
    init(dto: CastDetailResponse) {
        self.id = dto.id
        self.name = dto.name
        self.biography = dto.biography
        self.originPlace = dto.placeOfBirth?.split(separator: ",").first.map(String.init) ?? "N/A"
        self.birthYear = dto.birthday?.split(separator: "-").first.map(String.init) ?? "N/A"
        self.popularity = dto.popularity
        self.imagePath = dto.profilePath.flatMap { URL(string: "https://image.tmdb.org/t/p/w185\($0)") }
    }
    
    init(dto: CompanyDetailResponse) {
        self.id = dto.id
        self.name = dto.name
        self.biography = dto.description
        self.originPlace = dto.originCountry
        self.birthYear = "N/A"
        self.popularity = 0
        self.imagePath = dto.logoPath.flatMap { URL(string: "https://image.tmdb.org/t/p/w185\($0)") }
    }
}
