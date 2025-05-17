//
//  RootView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 17..
//

import SwiftUI
import Combine

struct RootView: View {
    @State var selectedTab: Int = 0
    @StateObject private var viewModel = RootViewModel()

    var body: some View {
        ZStack(alignment: .top) {
            MainTabView()

            if !viewModel.isConnected {
                OfflineBannerView()
            }
        }
    }
}
