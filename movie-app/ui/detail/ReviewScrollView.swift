//
//  ReviewScrollView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 24..
//

import SwiftUI

struct ReviewScrollView: View {
    let reviews: [MediaItemReview]
    
    var body: some View {
        VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
            Text("detail.topReviews".localized())
                .font(Fonts.overviewText)
            
            if reviews.isEmpty {
                Text("detail.noReviews".localized())
                    .font(Fonts.paragraph)
                    .foregroundColor(.gray)
            } else {
                VStack(alignment: .leading, spacing: LayoutConst.normalPadding) {
                    HStack {
                        if reviews.indices.contains(0) {
                            ReviewCell(review: reviews[0])
                        }
                        Spacer()
                        if reviews.indices.contains(1) {
                            ReviewCell(review: reviews[1])
                        }
                    }
                    HStack {
                        if reviews.indices.contains(2) {
                            ReviewCell(review: reviews[2])
                        }
                        Spacer()
                        if reviews.indices.contains(3) {
                            ReviewCell(review: reviews[3])
                        }
                    }
                }
                .padding(.horizontal, LayoutConst.normalPadding)
            }
        }
    }
}
