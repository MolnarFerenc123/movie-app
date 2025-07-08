//
//  GenreMotdCell.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 03..
//

import SwiftUI

struct GenreMotdCell: View {
    let mediaItemDetail: MediaItemDetail
    
    var body: some View {
        NavigationLink (destination: DetailView(mediaItem: mediaItemDetail.asMediaItem())){
            ZStack(alignment: .bottomLeading) {
                LoadImageView(url: mediaItemDetail.imageUrl)
                    .frame(width: 370, height: 185)
                    .cornerRadius(12)
                
                HStack {
                    VStack(alignment: .leading) {
                        Text(mediaItemDetail.genreList)
                            .font(Fonts.paragraphList)
                        Text(mediaItemDetail.title)
                            .font(Fonts.title)
                    }
                    .padding(LayoutConst.normalPadding)
                    
                    Spacer()
                    
                    Image(.playButton)
                        .frame(width: 48, height: 48)
                        .padding(LayoutConst.normalPadding)
                }
            }
            .padding(LayoutConst.maxPadding)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
