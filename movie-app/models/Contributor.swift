//
//  Contributor.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 12..
//
import Foundation

struct Contributor: Identifiable{
    let id: Int
    let name: String
    let profileImageUrl: URL?
    
    init(id: Int, name: String, profileImageUrl: URL?) {
        self.id = id
        self.name = name
        self.profileImageUrl = profileImageUrl
    }
    
    init(dto: ContributorResponse) {
        self.id = dto.id
        self.name = dto.name
        var imageUrl: URL? {
            dto.profileImagePath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.profileImageUrl = imageUrl
    }
}
