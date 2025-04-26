//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

struct FavoriteListView: View {
    @StateObject private var viewModel = FavoriteListViewModel()
    let columns = [
        GridItem(.adaptive(minimum: 380), spacing: 16)
    ]
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Favourites")
                .font(Fonts.heading)
                .padding(.top, 41)
                .padding(.leading, 21)
                .padding(.bottom, 35)
            ScrollView {
                LazyVGrid(columns: columns, spacing: 10) {
                    ForEach(viewModel.movies) { movie in
                        MovieCellView(movie: movie, imageHeight: 180, showFavouriteIcon: true)
                            .padding(.horizontal, 25)
                    }
                }
            }
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                Task {
                    await viewModel.loadFavorites()
                }
            }
            
            
        }
    }
}

#Preview {
    FavoriteListView()
}
