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
    
    var body: some View {
        var mediaItemDetail : MediaItemDetail{
            detailViewModel.mediaItemDetail
        }
        
        return ScrollView {
            VStack (alignment: .leading, spacing: LayoutConst.largePadding){
                AsyncImage(url: mediaItemDetail.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.3)
                            ProgressView()
                        }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180,alignment: .top)
                    case .failure:
                        ZStack {
                            Color.red.opacity(0.3)
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
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
                    StyledButton(style: .outlined, title: "detail.rate")
                    StyledButton(style: .filled, title: "detail.visit.imdb")
                }
                VStack(alignment: .leading, spacing: 12){
                    Text(LocalizedStringKey("detail.title"))
                        .font(Fonts.overviewText)
                    Text(mediaItemDetail.overview)
                        .font(Fonts.paragraph)
                }
                ContributorHScrollView(title: "publishers.and.companies.subtitle", contributors: detailViewModel.cast)
                ContributorHScrollView(title: "cast.subtitle", contributors: mediaItemDetail.productionCompanies)
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
