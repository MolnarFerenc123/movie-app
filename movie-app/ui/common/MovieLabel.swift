//
//  MovieLabel.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 26..
//

import SwiftUI

enum MovieLabelType {
    case rating(_ value: Double)
    case voteCount(_ voteCount: Int)
    case popularity(_ popularity: Double)
    case closedCaption(_ closedCaption: Bool)
}

struct MovieLabel : View {
    let type : MovieLabelType
    
    var body : some View {
        var imageRes : ImageResource
        var text : String
        switch type {
        case .rating(let value):
            imageRes = .ratingStar
            text = String(format: "%.1f", value)
        case .voteCount(let voteCount):
            imageRes = .heart
            text = String(format: "%d M", voteCount)
        case .popularity(let popularity):
            imageRes = .person
            text = String(format: "%.0f M", popularity)
        case .closedCaption(let closedCaption):
            imageRes = .closedCaption
            text = closedCaption ? "closed.caption.available" : "closed.caption.unavailable"
        }
        
        return HStack(spacing: 6) {
            Image(imageRes)
            Text(LocalizedStringKey(text))
                .font(Fonts.labelBold)
        }
        .padding(6)
        .background(Color.main.opacity(0.5))
        .cornerRadius(12)

    }
}
