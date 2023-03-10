//
//  EasyCryptoApp.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

@main
struct EasyCryptoApp: App {
    
    var body: some Scene {
        
        let _ = DIContainer.shared.registration()
        
        WindowGroup {
            MainCoordinator(viewModel: MainViewModel())
        }
    }
}
