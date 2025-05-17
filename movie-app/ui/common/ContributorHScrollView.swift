//
//  ContributorHScrollView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 12..
//
import SwiftUI

struct ContributorHScrollView: View {
    let title: String
    let contributors: [Contributor]
    
    var body: some View {
        Text(LocalizedStringKey(title))
            .font(Fonts.overviewText)
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(contributors) { contributor in
                    VStack(alignment: .leading){
                        LoadImageView(url: contributor.profileImageUrl)
                            .padding(.bottom, 12)
                        SubNamesView(name: contributor.name)
                    }
                }
            }
        }
        
    }
}

struct SubNamesView: View {
    var name: String
    
    var body: some View {
        var subNames = name.split(separator: " ").map { String($0) }
        let firstName = subNames.first ?? ""
        let remainingNames = subNames.dropFirst().joined(separator: " ")
        Text(firstName)
            .font(Fonts.paragraph)
            .padding(.bottom, 4)
        Text(remainingNames)
            .font(Fonts.overviewText)
    }
}
