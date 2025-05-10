//
//  Detail.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let mediaItem: MediaItem
    
    var body: some View {
        ScrollView {
            VStack (alignment: .leading){
                AsyncImage(url: viewModel.mediaItemDetail.imageUrl) { phase in
                    switch phase {
                    case .empty:
                        ZStack {
                            Color.gray.opacity(0.3)
                            ProgressView()
                        }
                        
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180,alignment: .top)
                    case .failure:
                        ZStack {
                            Color.red.opacity(0.3)
                            Image(systemName: "photo")
                                .foregroundColor(.white)
                        }
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(maxHeight: 180)
                .frame(maxWidth: .infinity)
                .clipped()
                .cornerRadius(12)
            }
        }
        .showAlert(model: $viewModel.alertModel)
        .onAppear{
            viewModel.mediaIdSubject.send(mediaItem.id)
        }
    }
}
