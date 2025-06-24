//
//  SettingsViewModel.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 05. 09..
//

import Foundation

protocol SettingsViewModelProtocol: ObservableObject{
    
}

class SettingsViewModel: SettingsViewModelProtocol {
    @Published public var selectedLanguage: String = Bundle.getLangCode()
    
    private let themeKey = "color-scheme"
    
    @Published public var selectedTheme: Theme {
        didSet {
            UserDefaults.standard.set(selectedTheme.rawValue, forKey: themeKey)
        }
    }
    
    init(){
        let storedTheme = UserDefaults.standard.string(forKey: themeKey)
        self.selectedTheme = Theme(rawValue: storedTheme ?? "") ?? .dark
    }
    
    func changeLang(lang: String) {
        self.selectedLanguage = lang
        Bundle.setLanguage(lang: lang)
    }
    
    func changeTheme(_ theme: Theme){
        self.selectedTheme = theme
    }
}
