//
//  MovieError.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//
import Foundation

enum MovieError : Error {
    case invalidApiKeyError(message: String)
    case unexpectedError
    case resourceNotFound
    
    var domain : String {
        switch self {
        case .invalidApiKeyError, .unexpectedError, .resourceNotFound:
            return "MovieError"
        }
    }
}

extension MovieError : LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidApiKeyError(let message):
            return message
        case .unexpectedError:
            return "Unexpected error"
        case .resourceNotFound:
            return "Resource is not found"
        }
    }
}
