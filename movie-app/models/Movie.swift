//
//  Movie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//
import Foundation

struct Movie: Identifiable {
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let popularity: Double
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, popularity: Double) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.popularity = popularity
    }
    
    init(dto: MovieResponse) {
        let year = String(dto.releaseDate.prefix(4))
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage
        self.voteCount = dto.voteCount
        self.popularity = dto.popularity
        
    }
    
}
