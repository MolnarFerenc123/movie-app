//
//  MediaItemDetail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//
import Foundation

struct MediaItemDetail: Identifiable{
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let summary: String?
    let popularity: Double
    
    init() {
        self.id = 0
        self.title = ""
        self.year = ""
        self.duration = ""
        self.imageUrl = nil
        self.rating = 0.0
        self.voteCount = 0
        self.summary = nil
        self.popularity = 0.0
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, summary: String? = nil, popularity: Double = 0) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.summary = summary
        self.popularity = popularity
    }
    
    init(dto: MovieDetailResponse) {
        let releaseDate: String? = dto.releaseDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
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
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.summary = nil
        self.popularity = dto.popularity
    }
    
}
