//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

struct FavoritesView: View {
    @StateObject private var viewModel = FavoritesViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 380), spacing: 16)
    ]
    
    var body: some View {
        VStack{
            NavigationView{
                ZStack(alignment: .topTrailing){
                    Image(.redQuarterCircle)
                        .ignoresSafeArea(.all)
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(viewModel.movies) { movie in
                                NavigationLink(destination: DetailView(mediaItem: movie)){
                                    MovieCell(movie: movie, imageHeight: 180, showFavouriteIcon: true)
                                        .padding(.horizontal, 25)
                                    
                                }
                                .buttonStyle(PlainButtonStyle())
                                .accessibilityLabel("MediaItem\(movie.id)")
                            }
                        }
                    }
                    
                    .scrollDismissesKeyboard(.interactively)
                    .padding(.top, 20)
                    .navigationTitle("favoriteMovies.title".localized())
                    .accessibilityLabel(AccessibilityLabels.favoritesScrollView)
                }
                .onAppear{
                    viewModel.viewLoaded.send(())
                }
            }
            
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    FavoritesView()
}
