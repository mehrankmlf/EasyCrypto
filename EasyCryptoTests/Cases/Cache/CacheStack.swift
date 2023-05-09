//
//  CacheStack.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/9/23.
//

import XCTest
import CoreData
import Combine
@testable import EasyCrypto

class CacheStack {

  private static let model: NSManagedObjectModel = {
    let modelURL = Bundle.main.url(
        forResource: Constants.DBName.coinENt,
      withExtension: "momd"
    )!
    return NSManagedObjectModel(contentsOf: modelURL)!
  }()

  lazy var mainContext: NSManagedObjectContext = {
    storeContainer.viewContext
  }()

  lazy var storeContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: Constants.DBName.coinENt)
    container.loadPersistentStores { _, error in
      if let error {
        fatalError("An error occurred while loading the Core Data: \(error.localizedDescription)")
      }
    }
    return container
  }()
}
