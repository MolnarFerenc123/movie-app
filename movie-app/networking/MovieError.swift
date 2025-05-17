//
//  MovieError.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//
import Foundation

enum MovieError : Error {
    case invalidApiKeyError(message: String)
    case clientError
    case noInternetError
    case unexpectedError
    
    var domain : String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .clientError, .noInternetError:
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
        }
    }
}

