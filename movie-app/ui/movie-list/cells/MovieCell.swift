//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import SwiftUI

struct MovieCell: View {
    @StateObject private var viewModel = MovieCellViewModel()
    var movie: MediaItem
    var imageHeight: CGFloat?
    var imageWidth: CGFloat?
    var showFavouriteIcon: Bool
    
    init(movie: MediaItem, imageHeight: CGFloat?, imageWidth: CGFloat? = .infinity, showFavouriteIcon: Bool) {
        self.movie = movie
        self.imageHeight = imageHeight
        self.imageWidth = imageWidth
        self.showFavouriteIcon = showFavouriteIcon
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    LoadImageView(url: movie.imageUrl)
                        .frame(height: imageHeight)
                        .clipped()
                        .cornerRadius(12)
                }
                HStack{
                    MovieLabel(type: .rating(movie.rating))
                    MovieLabel(type: .voteCount(movie.voteCount))
                    if showFavouriteIcon {
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(true ? .favorite : .noFavorite)
                                .onTapGesture {
                                    viewModel.favoriteButtonTapped.send(movie.id)
                                }
                        }
                        
                    }
                    
                }
                .padding(LayoutConst.smallPadding)
                
            }
            HStack{
                VStack (alignment: .leading){
                    Text(movie.title)
                        .font(Fonts.subheading)
                        .multilineTextAlignment(.leading)
                    
                    Text("\(movie.year)")
                        .font(Fonts.paragraph)
                    
                    Text("\(movie.duration)")
                        .font(Fonts.caption)
                }
                Spacer()
                Link(destination: URL(string: "https://mixdrop.stream/search.php?s=\(movie.title.replacingOccurrences(of: " ", with: "+"))")!){
                    Image(.playButton)
                }
            }
            .frame(width: imageWidth)
            Spacer()
        }
        .contentShape(Rectangle())
    }
}
