//
//  EasyCryptoApp.swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 1/23/23.
//

import SwiftUI

@main
struct EasyCryptoApp: App {

    let coreDataManager = CoreDataManager.preview

    var body: some Scene {
        let _ = DIContainer.shared.registration()
        WindowGroup {
            MainCoordinator(viewModel: MainViewModel())
                .environment(\.managedObjectContext, coreDataManager.container.viewContext)
        }
    }
}
