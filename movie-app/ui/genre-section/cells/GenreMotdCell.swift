//
//  GenreMotdCell.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 06. 03..
//

import SwiftUI

struct GenreMotdCell: View {
    let mediaItem: MediaItemDetail
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LoadImageView(url: mediaItem.imageUrl)
                .frame(width: 370, height: 185)
                .cornerRadius(12)
            
            HStack {
                VStack(alignment: .leading) {
                    Text(mediaItem.genreList)
                        .font(Fonts.paragraphList)
                    Text(mediaItem.title)
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
}
