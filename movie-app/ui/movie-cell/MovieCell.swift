//
//  MovieCellView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//

import SwiftUI

struct MovieCell: View {
    let movie: Movie
    let imageHeight: CGFloat?
    let showFavouriteIcon: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
                HStack(alignment: .center) {
                    AsyncImage(url: movie.imageUrl) { phase in
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
                                .frame(height: imageHeight,alignment: .top)
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
                    .frame(height: imageHeight)
                    .frame(maxWidth: .infinity)
                    .clipped()
                    .cornerRadius(12)
                }
                HStack{
                    HStack(spacing: 10) {
                        Image(.ratingStar)
                        Text(String(format: "%.1f", movie.rating))
                            .font(Fonts.labelBold)
                    }
                    .padding(6)
                    .background(Color.main.opacity(0.5))
                    .cornerRadius(12)
                    HStack(spacing: 10) {
                        Image(.heart)
                        Text(String(format: "%.0f M", movie.popularity))
                            .font(Fonts.labelBold)
                    }
                    .padding(6)
                    .background(Color.main.opacity(0.5))
                    .cornerRadius(12)
                    if showFavouriteIcon {
                        Spacer()
                        Image(.favourite)
                    }
                    
                }
                .padding(6)
                
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
}
