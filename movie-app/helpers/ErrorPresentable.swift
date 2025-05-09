//
//  ErrorPrentable.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 06..
//

import Foundation

protocol ErrorPresentable {
    
    func toAlertModel(_ error: Error) -> AlertModel
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(title: "unexpected.error.title", message: "unexpected.error.message", dismissButtonTitle: "button.close.text")
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(title: "API Error", message: message, dismissButtonTitle: "button.close.text")
        case .resourceNotFound:
            return AlertModel(title: "resource.not.found.error.title", message: "resource.not.found.error.message", dismissButtonTitle: "button.close.text")
        case .unexpectedError:
            return AlertModel(title: "unexpected.error.title", message: "unexpected.error.message", dismissButtonTitle: "button.close.text")
        default:
            return AlertModel(title: "unexpected.error.title", message: "unexpected.error.message", dismissButtonTitle: "button.close.text")
        }
    }
    
}
