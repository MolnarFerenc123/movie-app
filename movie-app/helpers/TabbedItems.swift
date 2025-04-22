//
//  TabbedItems.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

enum TabbedItems: Int, CaseIterable {
    case home = 0
    case theatres
    case favorite
    case more
    
    var iconName: String {
        switch self {
        case .home:
            return "home-tab-white"
        case .theatres:
            return "theaters-tab-white"
        case .favorite:
            return "favorite-tab-white"
        case .more:
            return "more-tab-white"
        }
    }
}
