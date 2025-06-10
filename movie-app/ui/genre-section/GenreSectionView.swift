//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation
import Shimmer

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModelImpl()
    
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topTrailing){
                Image(.redQuarterCircle)
                    .ignoresSafeArea(.all)
                VStack {
                    GenreMotdCell(mediaItem: viewModel.motdMovieDetail ?? MediaItemDetail())
                    List(viewModel.genres){ genre in
                        ZStack {
                            let mediaItems = viewModel.getMediaItemsByGenre(genre.id)
                            
                            MediaItemListByGenre(genre: genre, mediaItems: mediaItems)
                                .onAppear{
                                    if viewModel.mediaItemsByGenre[genre.id] == nil {
                                        viewModel.loadMediaItems(genreId: genre.id)
                                    }
                                }
                            //                            .animation(.easeInOut(duration: 0.8))
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                    .listStyle(.plain)
                    .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title".localized())
                    
                }
            }
            .showAlert(model: $viewModel.alertModel)
            .onAppear{
                viewModel.loadGenres()
                viewModel.genresAppeared()
            }
        }
    }
}

#Preview {
    GenreSectionView()
}
