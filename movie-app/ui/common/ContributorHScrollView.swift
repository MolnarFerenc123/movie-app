//
//  ContributorHScrollView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 12..
//
import SwiftUI

struct ContributorHScrollView: View {
    enum NavigationType {
        case none
        case person
        case company
    }
    
    
    let title: String
    let contributors: [Contributor]
    var navigationType: NavigationType = .none
    
    var body: some View {
        Text(title.localized())
            .font(Fonts.overviewText)
        ScrollView(.horizontal){
            HStack(spacing: 20){
                ForEach(contributors) { contributor in
                    switch navigationType {
                    case .none:
                        VStack(alignment: .leading){
                            LoadImageView(url: contributor.profileImageUrl)
                                .frame(width: 56, height: 56)
                                .cornerRadius(28)
                                .padding(.bottom, 12)
                            SubNamesView(name: contributor.name)
                        }
                        .frame(width: 56)
                    case .person:
                        NavigationLink(destination: ContributorDetailView(contributorIdType: .castMember(id: contributor.id))) {
                            VStack(alignment: .leading){
                                LoadImageView(url: contributor.profileImageUrl)
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(28)
                                    .padding(.bottom, 12)
                                SubNamesView(name: contributor.name)
                            }
                            .frame(width: 56)
                        }
                        .buttonStyle(PlainButtonStyle())
                    case .company:
                        NavigationLink(destination: ContributorDetailView(contributorIdType: .company(id: contributor.id))) {
                            VStack(alignment: .leading){
                                LoadImageView(url: contributor.profileImageUrl)
                                    .frame(width: 56, height: 56)
                                    .cornerRadius(28)
                                    .padding(.bottom, 12)
                                SubNamesView(name: contributor.name)
                            }
                            .frame(width: 56)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
        
    }
}

struct SubNamesView: View {
    var name: String
    
    var body: some View {
        let subNames = name.split(separator: " ").map { String($0) }
        let firstName = subNames.first ?? ""
        let remainingNames = subNames.dropFirst().joined(separator: " ")
        Text(firstName)
            .font(Fonts.paragraph)
            .padding(.bottom, 4)
            .lineLimit(1)
        Text(remainingNames)
            .font(Fonts.overviewText)
            .lineLimit(1)
    }
}
