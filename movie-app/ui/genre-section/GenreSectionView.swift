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
                        
                        GenreSectionCell(genre: genre)
                    }
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                }
                .listStyle(.plain)
                .navigationTitle(Environments.name == .tv ? "TV" : "genreSection.title")
            }
            
        }
        .showAlert(model: $viewModel.alertModel)
    }
}

#Preview {
    GenreSectionView()
}
