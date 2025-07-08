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
    let runtime: Int
    let imageUrl: URL?
    let rating: Double
    let voteCount: Int
    let summary: String?
    let popularity: Double
    let adult: Bool
    let genres: [String]
    let spokenLanguages: [String]
    let overview: String
    let imdbURL: URL?
    let productionCompanies: [Contributor]
    let showType: MediaItemType
    
    init() {
        self.id = 0
        self.title = ""
        self.year = ""
        self.runtime = 0
        self.imageUrl = nil
        self.rating = 0.0
        self.voteCount = 0
        self.summary = nil
        self.popularity = 0.0
        self.adult = false
        self.genres = []
        self.spokenLanguages = []
        self.overview = ""
        self.productionCompanies = []
        self.imdbURL = nil
        self.showType = .unknown
    }
    
    init(id: Int = 0, title: String = "", year: String = "", runtime: Int = 0, imageUrl: URL? = nil, rating: Double = 0.0, voteCount: Int = 0, summary: String? = nil, popularity: Double = 0.0, adult: Bool = false, genres: [String] = [], spokenLanguages: [String] = [],
         overview: String = "", imdbURL: URL? = nil, productionCompanies: [Contributor] = [], showType: MediaItemType) {
        self.id = id
        self.title = title
        self.year = year
        self.runtime = runtime
        self.imageUrl = imageUrl
        self.rating = rating
        self.voteCount = voteCount
        self.summary = summary
        self.popularity = popularity
        self.adult = adult
        self.genres = genres
        self.spokenLanguages = spokenLanguages
        self.overview = overview
        self.productionCompanies = productionCompanies
        self.imdbURL = imdbURL
        self.showType = showType
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
        
        var imdbURL: URL? {
            dto.imdbId.flatMap{
                URL(string: "https://www.imdb.com/title/\($0)/")
            }
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.runtime = dto.runtime
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.summary = nil
        self.popularity = dto.popularity
        self.adult = dto.adult
        self.genres = dto.genres
            .map{ genre in
                genre.name
            }
        self.spokenLanguages = dto.spokenLanguages
            .map{ language in
                language.englishName
            }
        self.overview = dto.overview
        self.imdbURL = imdbURL
        self.productionCompanies = dto.productionCompanies
            .map({Contributor(dto: $0)})
        self.showType = .movie
    }
    
    init(dto: TVDetailResponse) {
        let firstAirDate: String? = dto.firstAirDate
        let prefixedYear: Substring = firstAirDate?.prefix(4) ?? "-"
        let year = String(prefixedYear)
        
        let imageUrl: URL? = dto.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }
        
        self.id = dto.id
        self.title = dto.title
        self.year = year
        self.runtime = dto.episodeRunTime.first ?? 0
        self.imageUrl = imageUrl
        self.rating = dto.voteAverage ?? 0.0
        self.voteCount = dto.voteCount ?? 0
        self.overview = dto.overview
        self.popularity = dto.popularity
        self.adult = dto.adult
        self.genres = dto.genres.map { $0.name }
        self.imdbURL = nil
        self.productionCompanies = dto.productionCompanies.map { Contributor(dto: $0) }
        self.showType = .tv
        self.spokenLanguages = dto.spokenLanguages
            .map{ language in
                language.englishName
            }
        self.summary = nil
    }
    
    var genreList: String {
        genres.joined(separator: ", ")
    }
    
    var langList :String {
        spokenLanguages.joined(separator: ", ")
    }
    
    var runTimeString : String {
        var time = self.runtime
        var toReturn = ""
        toReturn += "\(time / 60)h "
        time -= time/60
        toReturn += "\(time)min"
        return toReturn
    }
    
}
