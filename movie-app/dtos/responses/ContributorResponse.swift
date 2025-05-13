//
//  ContributorResponse.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 12..
//
import Foundation

struct ContributorListResponse : Decodable {
    let contributors: [ContributorResponse]
    
    enum CodingKeys: String, CodingKey {
        case contributors = "cast"
    }
}

struct ContributorResponse : Decodable {
    let id: Int
    let name: String
    let profileImagePath: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case profileImagePath = "profile_path"
    }
}
