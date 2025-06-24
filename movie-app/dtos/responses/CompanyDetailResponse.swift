//
//  CompanyDetail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 14..
//

import Foundation

struct CompanyDetailResponse: Codable, Identifiable {
    let id: Int
    let name: String
    let description: String?
    let headquarters: String?
    let homepage: String?
    let logoPath: String?
    let originCountry: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, headquarters, homepage
        case logoPath = "logo_path"
        case originCountry = "origin_country"
    }
    
    var logoURL: URL? {
        guard let logoPath = logoPath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
} 
