//
//  SplashScreen.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 31..
//

import SwiftUI
import Lottie

struct SplashScreen: View {
    @State var animationFinished = false
    @AppStorage("color-scheme") var colorScheme: Theme = .dark
    
    var body: some View {
        if animationFinished {
            RootView()
                .preferredColorScheme(ColorScheme(theme: colorScheme))
        } else {
            LottieView(animation: LottieAnimation.named("movies"))
                .playing(loopMode: .repeatBackwards(1))
                .animationSpeed(3)
                .animationDidFinish { _ in
                    animationFinished = true
                }
        }
    }
}
