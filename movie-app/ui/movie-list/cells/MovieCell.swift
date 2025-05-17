//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import SwiftUI

struct MovieCell: View {
    @StateObject private var viewModel = MovieCellViewModel()
    let movie: MediaItem
    let imageHeight: CGFloat?
    let showFavouriteIcon: Bool
    
    var body: some View {
        NavigationLink(destination: DetailView(mediaItem: movie)){
            VStack(alignment: .leading, spacing: 8) {
                ZStack(alignment: .topLeading) {
                    HStack(alignment: .center) {
                        LoadImageView(url: movie.imageUrl)
                            .frame(height: imageHeight)
                            .frame(maxWidth: .infinity)
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
                            .lineLimit(2)
                        
                        Text("\(movie.year)")
                            .font(Fonts.paragraph)
                        
                        Text("\(movie.duration)")
                            .font(Fonts.caption)
                    }
                    Spacer()
                    Image(.playButton)
                }
                
                
                Spacer()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}
