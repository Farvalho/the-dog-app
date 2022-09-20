//
//  DogApp.swift
//  Dog
//
//  Created by Fábio Carvalho on 15/09/2022.
//

import SwiftUI

@main
struct DogApp: App {
    
    // On app launch
    init() {
        // Reset offline mode
        UserDefaults.standard.set(false, forKey: "isOfflineMode")
    }

    var body: some Scene {
        WindowGroup {
            BaseAppView()
        }
    }
}
