//
//  RootView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import SwiftUI
import Lottie
import Combine

struct RootView: View {
    @State var selectedTab: Int = 0
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            MainTabView()

            OfflineBannerView()
                .padding(.top, viewModel.bannerAppear ? 0 : -200)
                .animation(.easeInOut, value: viewModel.bannerAppear)
        }
    }
}
