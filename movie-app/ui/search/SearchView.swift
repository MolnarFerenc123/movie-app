//
//  SearchMovie.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 17..
//

import SwiftUI
import InjectPropertyWrapper
import Foundation

struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()
    
    let columns = [
        GridItem(.adaptive(minimum: 380), spacing: 16)
    ]
    
    @FocusState private var textFieldIsFocused: Bool
    
    var body: some View{
        NavigationView{
            VStack{
                HStack {
                    Image(.searchIcon)
                    TextField("", text: $viewModel.searchText, prompt: Text("search.textfield.placeholder").foregroundColor(Color.mainInvert))
                        .foregroundStyle(Color.mainInvert)
                        .font(Fonts.paragraph)
                        .onChange(of: viewModel.searchText){
                            viewModel.startSearch.send(())
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
                
                
                if(viewModel.searchText.isEmpty) {
                    Spacer()
                    Text("search.empty.text")
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
                                MovieCell(movie: movie, imageHeight: 180, showFavouriteIcon: true)
                                    .padding(.horizontal, 25)
                            }
                        }
                    }
                    .scrollDismissesKeyboard(.interactively)
                }
                
            }
        }
    }
}




#Preview {
    SearchView()
}
