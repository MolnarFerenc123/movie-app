//
//  SearchMovie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 17..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

protocol SearchMovieViewModelProtocol : ObservableObject {
    
}

class SearchMovieViewModel: SearchMovieViewModelProtocol {
    @Published var movies: [Movie] = []
    
    @Inject
    private var service: MovieServiceProtocol

    func searchMovies(searchText: String) async {
        do {
            let request = FetchMoviesByTitleRequest(searchText: searchText)
            let movies = try await service.fetchMoviesByTitle(req: request)
            DispatchQueue.main.async {
                self.movies = movies
            }
        } catch {
            print("Error fetching movies: \(error)")
        }
    }
}

struct SearchMovieView: View {
    @StateObject private var viewModel = SearchMovieViewModel()
    
    @State var searchText: String = ""
    
    let columns = [
        GridItem(.adaptive(minimum: 380), spacing: 16)
    ]
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View{
        
        return VStack{
            HStack {
                Image(.searchIcon)
                TextField("", text: $searchText, prompt: Text("Movies, Director, Actor, Actress, etc.").foregroundColor(Color.mainInvert))
                    .foregroundStyle(Color.mainInvert)
                    .font(Fonts.paragraph)
                    
                    .onChange(of: searchText){ oldValue, newValue in
                        Task {
                            await viewModel.searchMovies(searchText: searchText
                            )
                        }
                    }
                    .focused($textFieldIsFocused)
            }
            .padding(21)
            .background(Color.mainInvert.opacity(0.15))
            .cornerRadius(100)
            .overlay(
                RoundedRectangle(cornerRadius: 100)
                    .stroke(Color.mainInvert, lineWidth: 0.5)
            )
            .padding(30)
            

            if(searchText.isEmpty) {
                Spacer()
                Text("Kezdj el gépelni a kereséshez")
                    .font(Fonts.title)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 100)
                    .foregroundStyle(Color.mainInvert)
                    .scrollDismissesKeyboard(.immediately)
                    .onTapGesture {
                        textFieldIsFocused = false
                    }
                Spacer()
            }else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(viewModel.movies) { movie in
                            MovieCellView(movie: movie, imageHeight: 180, showFavouriteIcon: true)
                                .padding(.horizontal, 25)
                        }
                    }
                }
                .scrollDismissesKeyboard(.interactively)
            }

        }
    }
}



#Preview {
    SearchMovieView()
}
