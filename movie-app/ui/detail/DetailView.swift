//
//  Detail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

import SwiftUI

struct DetailView: View {
    @StateObject private var detailViewModel = DetailViewModel()
    @StateObject private var movieCellViewModel = MovieCellViewModel()
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        var mediaItemDetail : MediaItemDetail{
            detailViewModel.mediaItemDetail
        }
        
        return ScrollView {
            VStack (alignment: .leading, spacing: LayoutConst.largePadding){
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                HStack{
                    MovieLabel(type: .rating(mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .closedCaption(mediaItemDetail.adult))
                }
                Text(mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                Text(mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                HStack(spacing: LayoutConst.normalPadding){
                    DetailLabel(title: "release.date", value: mediaItemDetail.year)
                    DetailLabel(title: "runtime", value: mediaItemDetail.runTimeString)
                    DetailLabel(title: "language", value: mediaItemDetail.langList)
                }
                HStack{
                    NavigationLink(destination: AddReviewView(mediaItemDetail: mediaItemDetail))
                    {
                        StyledButton(style: .outlined, action: .simple, title: "detail.rate")
                            .frame(width: 184, height: 56)
                    }
                    Spacer()
                    StyledButton(style: .filled, action: .simple ,title: "detail.visit.imdb")
                        .frame(width: 184, height: 56)
                }
                VStack(alignment: .leading, spacing: 12){
                    Text("detail.title".localized())
                        .font(Fonts.overviewText)
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                }
                ContributorHScrollView(title: "publishers.and.companies.subtitle", contributors: detailViewModel.cast, navigationType: .person)
                ContributorHScrollView(title: "cast.subtitle", contributors: mediaItemDetail.productionCompanies, navigationType: .company)
                ReviewScrollView(reviews: detailViewModel.reviews)
            }
            .padding(.horizontal, LayoutConst.maxPadding)
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    detailViewModel.favoriteButtonTapped.send(())
                }){
                    Image(detailViewModel.isFavorite ? .favoriteSmall : .noFavoriteSmall)
                        .resizable()
                        .frame(height: 48)
                        .frame(width: 48)
                }
                
            }
        }
        .showAlert(model: $detailViewModel.alertModel)
        .onAppear{
            detailViewModel.mediaIdSubject.send(mediaItem.id)
        }
    }
}
