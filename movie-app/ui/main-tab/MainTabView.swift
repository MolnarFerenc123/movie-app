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
            HStack{
                ForEach((TabbedItems.allCases), id: \.self){ item in
                        Spacer()
                        Button{
                            selectedTab = item.rawValue
                        }
                    label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                        Spacer()
                }
            }
            .padding(.top, 24)
            .padding(.bottom, 48)
            .background(.tabBarBackground)
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
                .aspectRatio(contentMode: .fit)
                .frame(width: 16, height: 18)
            Spacer()
        }
        .frame(width: 40, height: 40)
        .background(isActive ? .white : .clear)
        .cornerRadius(20)
        .accessibilityIdentifier(imageName)
    }
    
}
    
#Preview {
    MainTabView()
}
