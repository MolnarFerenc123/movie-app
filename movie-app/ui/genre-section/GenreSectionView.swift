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
                
                List{
                    GenreMotdCell(mediaItemDetail: viewModel.motdMovieDetail)
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    ForEach(Array(viewModel.genres.enumerated()), id: \.element.id) { index, genre in
                        ZStack {
                            let mediaItems = viewModel.getMediaItemsByGenre(genre.id)
                            
                            MediaItemListByGenre(genre: genre, mediaItems: mediaItems)
                        }
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title".localized())
                .accessibilityLabel(AccessibilityLabels.genreSectionCollectionView)
                .background(.clear)
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
