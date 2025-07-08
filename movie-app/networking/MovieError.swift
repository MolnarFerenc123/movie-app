//
//  MovieError.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//
import Foundation
import Combine

enum MovieError : Error {
    case invalidApiKeyError(message: String)
    case clientError
    case noInternetError
    case unexpectedError
    case mappingError(message: String)
    
    var domain : String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .noInternetError, .mappingError:
            return "MovieError"
        }
    }
}

extension MovieError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .clientError:
            return "client.error.message"
        case .unexpectedError:
            return "unexpected.error.message"
        case .noInternetError:
            return "no.internet.error.message"
        case .mappingError(let message):
            return message
        }
    }
}

extension MovieError: CustomNSError {
    
    var errorCode: Int {
        switch self {
        case .invalidApiKeyError:
            return 1000
        case .mappingError:
            return 1001
        case .clientError:
            return 1002
        case .unexpectedError:
            return 1003
        case .noInternetError:
            return 1004
        }
    }
    
}

extension Publisher where Failure == Error {
    func rethrowErrorAsMovieError() -> AnyPublisher<Output, MovieError> {
        self.mapError { error -> MovieError in
            let movieError = mapToMovieError(error)
            //Crashlytics.crashlytics().record(error: movieError)
            return movieError
        }
        .eraseToAnyPublisher()
    }
}

func mapToMovieError(_ error: Error) -> MovieError {
    if let movieError = error as? MovieError {
        return movieError
    }
    
    return .unexpectedError
}
