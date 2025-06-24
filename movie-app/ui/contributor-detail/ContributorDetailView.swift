//
//  ContributorDetailView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 14..
//

import SwiftUI

struct ContributorDetailView: View {
    @StateObject private var viewModel = ContributorDetailViewModel()
    @Environment(\.dismiss) private var dismiss
    
    let contributorIdType: ContributorDetailType
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            Color(UIColor.systemBackground)
                .edgesIgnoringSafeArea(.all)
            
            VStack{
                ScrollView {
                    if let contributor = viewModel.contributorDetail {
                        VStack(alignment: .leading, spacing: 24) {
                            HStack {
                                Spacer()
                                LoadImageView(url: contributor.imagePath)
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 370, height: 185)
                                    .cornerRadius(20)
                                Spacer()
                            }
                            
                            Text(contributor.name)
                                .font(Fonts.detailsTitle)
                                .foregroundColor(Color.primary)
                                .padding(.horizontal)
                            
                            HStack(spacing: 40) {
                                VStack(alignment: .leading) {
                                    Text("Birth year")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(contributor.birthYear ?? "-")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                
                                VStack(alignment: .leading) {
                                    Text("City")
                                        .font(Fonts.caption)
                                        .foregroundColor(Color.primary)
                                    Text(contributor.originPlace ?? "-")
                                        .font(Fonts.paragraph)
                                        .foregroundColor(Color.primary)
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Bio")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                Text(contributor.biography ?? "-")
                                    .font(Fonts.paragraph)
                                    .foregroundColor(Color.primary)
                            }
                            .padding(.horizontal)
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Popularity")
                                    .font(Fonts.caption)
                                    .foregroundColor(Color.primary)
                                HStack {
                                    Spacer()
                                    StarRatingView(rating: $viewModel.rating, starSize: 24, starViewType: .nonChangable)
                                    Spacer()
                                }
                            }
                            .padding(.horizontal)
                            
                        }
                        .padding(.bottom, 48)
                    } else {
                        ProgressView()
                    }
                }
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear {
            viewModel.contributorDetailTypeSubject.send(contributorIdType)
        }
    }
}
