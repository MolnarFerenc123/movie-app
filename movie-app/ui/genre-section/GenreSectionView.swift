//
//  ContentView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 05..
//

import SwiftUI

class GenreSectionViewModel: ObservableObject {
    @Published var genres: [Genre] = []
    
    func loadGenres() {
        self.genres = [
            Genre(id: 1, name: "Adventure"),
            Genre(id: 2, name: "Sci-fi"),
            Genre(id: 3, name: "Horror"),
            Genre(id: 4, name: "Comedy")
        ]
    }
}

struct GenreSectionView: View {
    @StateObject private var viewModel = GenreSectionViewModel()
    
    var body: some View {
        NavigationView {
            List(viewModel.genres){ genre in
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
            .navigationTitle("genreSection.title")
        }
        .onAppear {
            viewModel.loadGenres()
        }
    }
}

#Preview {
    GenreSectionView()
}
