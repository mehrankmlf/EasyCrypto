//
//  EasyCryptoApp.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

let isRunningUITests = ProcessInfo.processInfo.arguments.contains("isRunningUITests")

@main
struct EasyCryptoApp: App {

    let coreDataManager = CoreDataManager.preview
    
    init() {
        DIContainer.shared.registration()
    }

    var body: some Scene {
        WindowGroup {
            MainCoordinator(viewModel: MainViewModel())
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
