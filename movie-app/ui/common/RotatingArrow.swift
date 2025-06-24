//
//  RotatingArrow.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 31..
//

import SwiftUI

struct RotatingArrow: View {
    let isExpanded: Bool
    
    var body: some View {
        Image(.rightArrow)
            .rotationEffect(.degrees(isExpanded ? 90 : 0))
            .animation(.spring(response: 0.8), value: isExpanded)
    }
}
