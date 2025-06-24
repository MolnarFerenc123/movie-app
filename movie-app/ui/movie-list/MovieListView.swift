//
//  MovieListView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
    let columns = [
        GridItem(.adaptive(minimum: 150), spacing: 16)
    ]
    
    var body: some View {
            ScrollView {
                ZStack(alignment: .topTrailing){
                    Image(.redQuarterCircle)
                        .ignoresSafeArea(.all)
                        .offset(x: 0, y: -150)
                    LazyVGrid(columns: columns, spacing: 24) {
                        ForEach(Array(viewModel.movies.enumerated()), id: \.offset) { index, movie in
                            return MovieCell(movie: movie, imageHeight: 100, showFavouriteIcon: false)
                                .onAppear {
                                    if index == viewModel.movies.count - 1 {
                                        viewModel.genreIdSubject.send(genre.id)
                                    }
                                }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
                if viewModel.isLoading{
                    ProgressView()
                }
            }
            .navigationTitle(genre.name)
            .onAppear {
                viewModel.genreIdSubject.send(genre.id)
            }
            .refreshable {
                viewModel.refreshSubject.send()
            }
            .showAlert(model: $viewModel.alertModel)
        
    }
}



