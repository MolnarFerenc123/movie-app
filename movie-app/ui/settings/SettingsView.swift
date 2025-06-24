//
//  SettingsView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 09..
//

import SwiftUI
import InjectPropertyWrapper
import FirebaseCrashlytics

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("settings.chooseLanguage".localized())
                .font(Fonts.subheading)
                .padding(.bottom, LayoutConst.maxPadding)
            HStack(spacing: 12) {
                StyledButton(style: viewModel.selectedLanguage == "en" ? .filled : .outlined, action: .simple, title: "settings.lang.english".localized())
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .fixedSize()
                    .onTapGesture {
                        viewModel.changeLang(lang: "en")
                    }
                Spacer()
                StyledButton(style: viewModel.selectedLanguage == "de" ? .filled : .outlined, action: .simple, title: "settings.lang.german".localized())
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .fixedSize()
                    .onTapGesture {
                        viewModel.changeLang(lang: "de")
                    }
                Spacer()
                StyledButton(style: viewModel.selectedLanguage == "hu" ? .filled : .outlined, action: .simple, title: "settings.lang.hungarian".localized())
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .fixedSize()
                    .onTapGesture {
                        viewModel.changeLang(lang: "hu")
                    }
            }
            .padding(.bottom, 43)
            
            Text("settings.chooseTheme".localized())
                .font(Fonts.subheading)
                .padding(.bottom, LayoutConst.maxPadding)
            HStack(spacing: 12) {
                StyledButton(style: viewModel.selectedTheme == .light ? .filled : .outlined, action: .simple, title: "settings.theme.light".localized())
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.changeTheme(.light)
                    }
                StyledButton(style: viewModel.selectedTheme == .dark ? .filled : .outlined, action: .simple, title: "settings.theme.dark".localized())
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        viewModel.changeTheme(.dark)
                    }
            }
            .padding(.bottom, 43)
            
            HStack(spacing: 12)  {
                StyledButton(style: .outlined, action: .simple, title: "Crash")
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        fatalError("Crash forced")
                    }
                StyledButton(style: .outlined, action: .simple, title: "No Internet error")
                    .font(Fonts.detailsButton)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity)
                    .onTapGesture {
                        Crashlytics.crashlytics().record(error: MovieError.noInternetError)
                    }
            }
            
            Spacer()
            VStack(spacing: LayoutConst.smallPadding) {
                Text("Version 0.9.1")
                Text("Created by Hell yeah")
            }
            .font(Fonts.subheading)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 66)
        }
        .padding(LayoutConst.maxPadding)
        .navigationTitle("settings.title".localized())
        .frame(maxHeight: .infinity, alignment: .top)    }
}

#Preview {
    SettingsView()
}
