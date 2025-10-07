//
//  MovieReview.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 24..
//

import Foundation

struct MediaItemReview: Identifiable {
    let id: String
    let author: String
    let content: String
    let rating: Double?
    let avatarURL: URL?
    
    init(id: String, author: String, content: String, rating: Double?, avatarURL: URL?) {
            self.id = id
            self.author = author
            self.content = content
            self.rating = rating
            self.avatarURL = avatarURL
        }
    
    init(dto: MovieReviewResponse) {
        self.id = dto.id
        self.author = dto.author
        self.content = dto.content
        self.rating = dto.authorDetails.rating
        self.avatarURL = dto.authorDetails.avatarPath.flatMap { path in
            if path.hasPrefix("/") {
                return URL(string: "https://image.tmdb.org/t/p/w500\(path)")
            } else {
                return URL(string: path)
            }
        }
    }
}
