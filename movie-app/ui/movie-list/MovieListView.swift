//
//  MovieListView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import SwiftUI
import InjectPropertyWrapper

protocol MovieListViewModelProtocol: ObservableObject {
    
}

class MovieListViewModel: MovieListViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MovieServiceProtocol
    
    func loadMovies(by genreId: Int) async {
        do {
            let request = FetchMoviesRequest(genreId: genreId)
            let movies = try await service.fetchMovies(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching genres: \(error)")
        }
    }
}

struct MovieListView: View {
    @StateObject private var viewModel = MovieListViewModel()
    let genre: Genre
    
//    let columns = [
//        GridItem(.flexible(), spacing: 16),
//        GridItem(.flexible(), spacing: 16)
//    ]
//    
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
                        ForEach(viewModel.movies) { movie in
                            MovieCell(movie: movie, imageHeight: 100, showFavouriteIcon: false)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                }
            }
            .navigationTitle(genre.name)
            .onAppear {
                Task {
                    await viewModel.loadMovies(by: genre.id)
                }
            }
        
    }
}



