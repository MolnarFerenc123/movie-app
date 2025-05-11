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
                        MovieLabel(type: .rating(movie.rating))
                        MovieLabel(type: .voteCount(movie.voteCount))
                        if showFavouriteIcon {
                            Spacer()
                            Button {
                                
                            } label: {
                                Image(.favourite)
                                    .onTapGesture {
                                        viewModel.mediaIdSubject.send(movie.id)
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
