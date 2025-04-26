//
//  ViewModelAssembly.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import Swinject
import Foundation

class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register((any MovieListViewModelProtocol).self) { _ in
            return MovieListViewModel()
        }.inObjectScope(.container)
        
        container.register((any GenreSectionViewModelProtocol).self) { _ in
            return GenreSectionViewModel()
        }.inObjectScope(.container)
        
        container.register((any SearchMovieViewModelProtocol).self) { _ in
            return SearchMovieViewModel()
        }.inObjectScope(.container)

        container.register((any FavoriteListViewModelProtocol).self) { _ in
            return FavoriteListViewModel()
        }.inObjectScope(.container)
    }
}
