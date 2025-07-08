//
//  Movie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//
import Foundation

struct MediaItem: Identifiable{
    let id: Int
    let title: String
    let year: String
    let duration: String
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let showType: MediaItemType
    
    init(id: Int = 0) {
        self.id = id
        self.title = ""
        self.year = ""
        self.duration = "duration"
        self.imageUrl = nil
        self.rating = 0.0
        self.voteCount = 0
        self.showType = .unknown
    }
    
    init(id: Int, title: String, year: String, duration: String, imageUrl: URL?, rating: Double, voteCount: Int, showType: MediaItemType) {
        self.id = id
        self.title = title
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.showType = showType
    }
    
    init(dto: MovieResponse) {
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
        self.showType = .movie
    }
    
    init(dto: TVResponse) {
        let releaseDate: String? = dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min" // TODO: placeholder – ha lesz ilyen adat, cserélhető
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        
        self.id = dto.id
        self.title = dto.name
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.showType = .tv
    }
    
    
    init(dto: CombinedMediaItemResponse){
        let releaseDate: String? = dto.releaseDate ?? dto.firstAirDate
        let prefixedYear: Substring = releaseDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        let duration = "1h 25min"
        
        var imageUrl: URL? {
            dto.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
        }
        self.id = dto.id
        self.title = dto.originalTitle ?? dto.originalName ?? "N/A"
        self.year = year
        self.duration = duration
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage
        self.voteCount = dto.voteCount
        switch dto.mediaType {
        case "movie":
            self.showType = .movie
        case "tv":
            self.showType = .tv
        default:
            self.showType = .unknown
        }
    }
}
