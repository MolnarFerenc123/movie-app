//
//  StarRatingView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 20..
//

import SwiftUI

enum StarViewType {
    case changable
    case nonChangable
}

struct StarRatingView: View {
    @Binding var rating: Int
    var starSize: CGFloat = 40.0
    let starViewType: StarViewType
    
    
    var body: some View {
        HStack(spacing: 12) {
            ForEach(0..<5, id: \.self) { index in
                switch starViewType {
                case .changable:
                    StarView(index: index,
                             isFilled: index <= rating,
                             onTap: {
                        rating = index
                    },
                             size: starSize)
                case .nonChangable:
                    StarView(index: index,
                             isFilled: index <= rating,
                             onTap: {},
                             size: starSize)
                }
                
            }
        }
    }
}
