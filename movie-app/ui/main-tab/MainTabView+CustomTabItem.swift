//
//  MainTabView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//
import SwiftUI

extension MainTabView{
    func CustomTabItem(imageName: String, isActive: Bool) -> some View{
        HStack{
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle( isActive ? .black : .white )
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 18)
            Spacer()
        }
        .frame(width: 40, height: 40)
        .background(isActive ? .white : .clear)
        .cornerRadius(20)
    }
    
}
