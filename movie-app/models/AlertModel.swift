//
//  AlertModel.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//

import Foundation
struct AlertModel : Identifiable {
    let id = UUID()
    let title : String
    let message : String
    let dismissButtonTitle: String
}
