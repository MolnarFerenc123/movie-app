//
//  ErrorPrentable.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 06..
//

protocol ErrorPresentable {
    
    func toAlertModel(_ error: Error) -> AlertModel
}

extension ErrorPresentable {
    func toAlertModel(_ error: Error) -> AlertModel{
        guard let error = error as? MovieError else {
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
        switch error {
        case .invalidApiKeyError(let message):
            return AlertModel(
                title: "api.error.title",
                message: message,
                dismissButtonTitle: "button.close.text"
            )
        case .clientError:
            return AlertModel(
                title: "client.error.title",
                message: error.localizedDescription,
                dismissButtonTitle: "button.close.text"
            )
        default:
            return AlertModel(
                title: "unexpected.error.title",
                message: "unexpected.error.message",
                dismissButtonTitle: "button.close.text"
            )
        }
    }
    
}
