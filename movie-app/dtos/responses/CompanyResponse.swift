//
//  ContributorResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 12..
//
import Foundation

struct CompanyResponse : Decodable {
    let id: Int
    let name: String
    let logoImagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case logoImagePath = "logo_path"
    }
}

