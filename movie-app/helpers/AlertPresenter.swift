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
            Alert(title: Text(model.title.localized()),
                  message: Text(model.message.localized()),
                  dismissButton: .default(Text(model.dismissButtonTitle.localized())) {
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
