//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    private var movieService: MovieServiceProtocol = MovieService()
    
    func loadGenres() async {
        do {
            #if SERIESDEV
            let request = FetchTvSeriesGenresRequest()
            let genres = try await movieService.FetchTvSeriesGenres(req: request)
            #else
            let request = FetchGenreRequest()
            let genres = try await movieService.FetchGenres(req: request)
            #endif
            
            DispatchQueue.main.async {
                self.genres = genres
            }
        } catch {
            print("Error fetchin genres: \(genres)")
        }
    }
}

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topTrailing){
                Image(.redQuarterCircle)
                    .ignoresSafeArea(.all)
                List(viewModel.genres.sorted{$0.name < $1.name}){ genre in
                    ZStack {
                        NavigationLink(destination: Text(genre.name)){
                            EmptyView()
                        }
                        HStack{
                            Text(genre.name)
                                .font(Fonts.title)
                                .foregroundStyle(.primary)
                            Spacer()
                            Image(.rightArrow)
                        }
                        
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle(Enviroment.name == .dev ? "DEV" : "PROD")
            }
                
            }
            .onAppear {
                Task {
                    await viewModel.loadGenres()
                }
            }
        }
}

#Preview {
    GenreSectionView()
}
