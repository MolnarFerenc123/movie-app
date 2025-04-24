//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView{
            ZStack(alignment: .topTrailing){
                Image(.redQuarterCircle)
                    .ignoresSafeArea(.all)
                List(viewModel.genres.sorted{$0.name < $1.name}){ genre in
                    ZStack {
                        NavigationLink(destination: MovieListView(genre:genre)){
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
                .navigationTitle(Enviroments.name == .tv ? "TV" : "genreSection.title")
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
