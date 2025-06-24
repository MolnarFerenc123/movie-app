//
//  ReviewCell.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 24..
//

import SwiftUI

struct ReviewCell: View {
    let review: MovieReview
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.smallPadding) {
            HStack {
                Text(review.author)
                    .font(Fonts.subheading)
                Spacer()
                if let rating = review.rating {
                    MovieLabel(type: .rating(rating))
                }
            }
            Text(review.content)
                .font(Fonts.paragraph)
                .lineLimit(4)
        }
    }
} 
