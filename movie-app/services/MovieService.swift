//
//  MovieService.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

import Foundation
import Moya

protocol MovieServiceProtocol {
    func FetchGenres(req: FetchGenreRequest) async throws -> [Genre]
}

class MovieService : MovieServiceProtocol {
    
    var moya: MoyaProvider<MultiTarget>!
    
    init() {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        
        self.moya = MoyaProvider<MultiTarget> (
            session: Session(configuration: configuration, startRequestsImmediately: false),
            plugins : [
                NetworkLoggerPlugin()
            ]
        )
    }
    
    func FetchGenres(req: FetchGenreRequest) async throws -> [Genre] {
        return try await withCheckedThrowingContinuation { continuation in
                    moya.request(MultiTarget(MoviesApi.fetchGenres(req: req))) { result in
                        switch result {
                        case .success(let response):
                            do {
                                let decodedResponse = try JSONDecoder().decode(GenreResponse.self, from: response.data)
                                continuation.resume(returning: decodedResponse.genres)
                            } catch {
                                continuation.resume(throwing: error)
                            }
                        case .failure(let error):
                            continuation.resume(throwing: error)
                        }
                    }
                }
    }
    
    
}
