//
//  Theme.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 31..
//

import SwiftUI

enum Theme: String{
    case light
    case dark
}

extension ColorScheme {
    init(theme: Theme) {
        switch theme {
        case .light:
            self = .light
        case .dark:
            self = .dark
        }
    }
}
