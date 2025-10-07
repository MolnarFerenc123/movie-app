//
//  Detail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject private var detailViewModel = DetailViewModel()
    @StateObject private var movieCellViewModel = MovieCellViewModel()
    let mediaItem: MediaItem
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    var body: some View {
        return ScrollView {
            VStack (alignment: .leading, spacing: LayoutConst.largePadding){
                LoadImageView(url: detailViewModel.mediaItemDetail.imageUrl)
                    .frame(maxHeight: 180)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                HStack{
                    MovieLabel(type: .rating(detailViewModel.mediaItemDetail.rating))
                    MovieLabel(type: .voteCount(detailViewModel.mediaItemDetail.voteCount))
                    MovieLabel(type: .popularity(detailViewModel.mediaItemDetail.popularity))
                    Spacer()
                    MovieLabel(type: .closedCaption(detailViewModel.mediaItemDetail.adult))
                }
                Text(detailViewModel.mediaItemDetail.genreList)
                    .font(Fonts.paragraph)
                Text(detailViewModel.mediaItemDetail.title)
                    .font(Fonts.detailsTitle)
                HStack(spacing: LayoutConst.normalPadding){
                    DetailLabel(title: "release.date", value: detailViewModel.mediaItemDetail.year)
                    DetailLabel(title: "runtime", value: detailViewModel.mediaItemDetail.runTimeString)
                    DetailLabel(title: "language", value: detailViewModel.mediaItemDetail.langList)
                }
                HStack{
                    NavigationLink(destination: AddReviewView(mediaItemDetail: detailViewModel.mediaItemDetail))
                    {
                        StyledButton(style: .outlined, action: .simple, title: "detail.rate")
                            .frame(width: 184, height: 56)
                    }
                    Spacer()
                    StyledButton(style: .filled, action: .link(detailViewModel.mediaItemDetail.imdbURL) ,title: "detail.visit.imdb")
                        .frame(width: 184, height: 56)
                }
                VStack(alignment: .leading, spacing: 12){
                    Text("detail.title".localized())
                        .font(Fonts.overviewText)
                    Text(detailViewModel.mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                }
                ContributorHScrollView(title: "publishers.and.companies.subtitle", contributors: detailViewModel.cast, navigationType: .person)
                ContributorHScrollView(title: "cast.subtitle", contributors: detailViewModel.mediaItemDetail.productionCompanies, navigationType: .company)
                ReviewScrollView(reviews: detailViewModel.reviews)
                
                Text("similars".localized())
                    .font(Fonts.title)
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(Array(detailViewModel.similarMediaItems.enumerated()), id: \.offset) { index, mediaItem in
                            NavigationLink(destination: DetailView(mediaItem: mediaItem)) {
                                MovieCell(movie: mediaItem, imageHeight: 100, showFavouriteIcon: false)
                                    .frame(width: 200)
                                    .onAppear {
                                        if index == detailViewModel.similarMediaItems.count - 1 {
                                            detailViewModel.similarMediasSubject.send(mediaItem)
                                        }
                                    }
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        if detailViewModel.isLoading{
                            ProgressView()
                        }
                    }
                }
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
            detailViewModel.mediaIdSubject.send(mediaItem)
            detailViewModel.similarMediasSubject.send(mediaItem)
        }
        .refreshable {
            detailViewModel.refreshSubject.send()
        }
    }
}
