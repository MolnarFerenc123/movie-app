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
        VStack(alignment: .leading){
            NavigationView{
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.movies) { movie in
                            MovieCell(movie: movie, imageHeight: 180, showFavouriteIcon: true)
                                .padding(.horizontal, 25)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }
            .navigationTitle("favoriteMovies.title")
        }
        .showAlert(model: $viewModel.alertModel)    }
}

#Preview {
    FavoritesView()
}
