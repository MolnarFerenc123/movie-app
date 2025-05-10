//
//  SettingsView.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 09..
//

import SwiftUI
import InjectPropertyWrapper

struct SettingsView: View {
    var body: some View {
        NavigationView {
            Text("Settings screen")
                .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
