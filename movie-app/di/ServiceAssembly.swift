//
//  ServiceAssembly.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Swinject
import Moya
import Foundation

class ServiceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(MoyaProvider<(MultiTarget)>.self) { _ in
            let configuration = URLSessionConfiguration.default
            configuration.headers = .default
            
            return MoyaProvider<MultiTarget> (
                session: Session(configuration: configuration,
                                        startRequestsImmediately: false),
                plugins: [
                    NetworkLoggerPlugin()
                ]
            )
        }.inObjectScope(.container)
        
        container.register(MovieServiceProtocol.self) { _ in
            return MovieService()
//            return MockMoviesService()
        }.inObjectScope(.container)
    }
}
