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
    let logoPath: String?
    
    var profileImageUrl: URL? {
        guard let logoPath = logoPath else{
            return nil
        }
        return URL(string: "https://image.tmdb.org/t/p/w500\(logoPath)")
    }
    
    init(id: Int, name: String, logoPath: String) {
        self.id = id
        self.name = name
        self.logoPath = logoPath
    }
    
    init(dto: ContributorResponse) {
        self.id = dto.id
        self.name = dto.name
        self.logoPath = dto.logoPath
    }
    
    init(dto: CompanyResponse) {
        self.id = dto.id
        self.name = dto.name
        self.logoPath = dto.logoPath
    }
}
