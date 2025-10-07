//
//  GlobalMethods.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 09..
//

import UIKit

func safeArea() -> UIEdgeInsets {
    (UIApplication.shared.connectedScenes.first as? UIWindowScene)?
        .windows.first?.safeAreaInsets ?? .zero
}
