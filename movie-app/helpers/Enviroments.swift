//
//  Enviroments.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 12..
//

struct Enviroment {
    enum Name {
        case prod
        case dev
    }

    #if ENV_PROD
        static let name: Name = .prod
    #else
        static let name: Name = .dev
    #endif
}
