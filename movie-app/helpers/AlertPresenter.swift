//
//  AlertPresenter.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 10..
//

import SwiftUI

struct AlertModifier: ViewModifier {
    @Binding var model: AlertModel?
    
    func body(content: Content) -> some View {
        content.alert(item: $model) { model in
            Alert(title: Text(LocalizedStringKey(model.title)), message: Text(LocalizedStringKey(model.message)), dismissButton: .default(Text(LocalizedStringKey(model.dismissButtonTitle))) {
                self.model = nil
            })
        }
    }
}

extension View {
    func showAlert(model: Binding<AlertModel?>) -> some
    View {
        self.modifier(AlertModifier(model: model))
    }
}
