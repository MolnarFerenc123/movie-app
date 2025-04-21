//
//  MainTabView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 18..
//
import SwiftUI

struct MainTabView: View {
    @State var selectedTab = 0
    
    init() {
            let transparentAppearence = UITabBarAppearance()
            transparentAppearence.configureWithTransparentBackground() // 🔑
            UITabBar.appearance().standardAppearance = transparentAppearence
        }
    
    var body: some View {
        VStack {
            TabView(selection: $selectedTab) {
                GenreSectionView()
                    .tag(0)
                SearchMovieView()
                    .tag(1)
            }
            .padding(.bottom, -10)
            ZStack{
                HStack{
                    Spacer()
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                        Spacer()
                    }
                }
                .padding(6)
            }
            .frame(height: 112)
            .background(Color.init(red: 34/255, green: 34/255, blue: 34/255))
            .cornerRadius(30)
        }
        .ignoresSafeArea()
    }
}


extension MainTabView{
    func CustomTabItem(imageName: String, isActive: Bool) -> some View{
        HStack{
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundStyle( isActive ? .black : .white )
                .frame(width: 16, height: 18)
            Spacer()
        }
        .frame(width: 60, height: 60)
        .background(isActive ? .white : .clear)
        .cornerRadius(100)
    }
}

#Preview {
    MainTabView()
}
