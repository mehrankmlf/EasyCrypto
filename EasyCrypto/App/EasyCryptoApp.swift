//
//  EasyCryptoApp.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

@main
struct EasyCryptoApp: App, DependencyAssemblerInjector {

    var body: some Scene {
        WindowGroup {
            MainCoordinator(viewModel: self.dependencyAssembler.makeMainViewModel())
        }
    }
}
