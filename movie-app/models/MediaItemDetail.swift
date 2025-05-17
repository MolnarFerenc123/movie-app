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
    let productionCompanies: [Contributor]
    
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
    }
    
    init(id: Int, title: String, year: String, runtime: Int, imageUrl: URL?, rating: Double, voteCount: Int, summary: String? = nil, popularity: Double = 0, adult: Bool = false, genres: [String] = [], spokenLanguages: [String] = [],
         overview: String = "", productionCompanies: [Contributor] = []) {
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
        self.productionCompanies = dto.productionCompanies
            .map({Contributor(dto: $0)})
        
    }
    
    var genreList :String {
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
