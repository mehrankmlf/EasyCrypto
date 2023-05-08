//
//  CacheTest.swift
//  EasyCryptoTests
//
//  Created by Mehran Kamalifard on 5/7/23.
//

import XCTest
import CoreData
@testable import EasyCrypto

class CacheTest: XCTestCase {
    
    lazy var mockPersistentContainer: NSPersistentContainer = {
        let persistentContainer = NSPersistentContainer(name: "CoinsDB", managedObjectModel: self.managedObjectModel)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        description.shouldAddStoreAsynchronously = false
        
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { (description, error) in
            precondition(description.type == NSInMemoryStoreType)
            
            if let error = error {
                fatalError("Unable to create in memory persistent store")
            }
        }
        
        return persistentContainer
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        return NSManagedObjectModel.mergedModel(from: [Bundle(for: type(of: self))])!
    }()
    
    func flush() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest<NSFetchRequestResult>(entityName: "ContactItem")
        let objects = try! mockPersistentContainer.viewContext.fetch(fetchRequest)
        
        objects.forEach { object in
            guard let object = object as? NSManagedObject else {
                return
            }
            mockPersistentContainer.viewContext.delete(object)
        }
        
        try? mockPersistentContainer.viewContext.save()
    }

    
}
