//
//  AppDelegate.swift
//  movie-app
//
//  Created by Ferenc Molnar on 2025. 04. 15..
//

import UIKit
import InjectPropertyWrapper
import Swinject
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    let assembler: MainAssembler
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        print("AppDelegate - App launched")
        
        FirebaseApp.configure()
        
        return true
    }
    
    override init() {
        assembler = MainAssembler.create(withAssemblies: [
            ServiceAssembly(),
            ViewModelAssembly()
        ])
        InjectSettings.resolver = assembler.container
    }
}
