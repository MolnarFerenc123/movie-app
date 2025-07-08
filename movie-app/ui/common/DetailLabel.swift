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
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title.localized())
                .font(Fonts.caption)
                .padding(.bottom, 5)
            Text(value.localized())
                .font(Fonts.paragraph)
        }
    }
}
