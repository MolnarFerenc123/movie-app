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
    
    private let languageManager = LanguageManager.shared
    
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
    func changeTheme(_ theme: Theme){
        self.selectedTheme = theme
    }
    
    
    
    func changeLang(lang: String) {
        languageManager.setLanguage(lang)
        self.selectedLanguage = lang
    }
}
