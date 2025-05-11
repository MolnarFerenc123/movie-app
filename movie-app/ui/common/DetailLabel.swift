//
//  DetailLable.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

import SwiftUI

struct DetailLabel: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(LocalizedStringKey(title))
                .font(Fonts.caption)
            Spacer()
            Text(LocalizedStringKey(value))
                .font(Fonts.paragraph)
        }
    }
}
