//
//  CoreDataManager.swift
//  EasyCrypto
//
//  Created by Mehran on 1/4/1402 AP.
//

import Foundation
import CoreData
import Combine

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

enum DecoderConfigurationError: Error {
  case missingManagedObjectContext
}

extension NSManagedObject {
    class var entityName: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

protocol EntityCreating {
    var viewContext: NSManagedObjectContext { get }
    func createEntity<T: NSManagedObject>() -> T
}

extension EntityCreating {
    func createEntity<T: NSManagedObject>() -> T {
        T(context: viewContext)
    }
}

protocol CoreDataFetchProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T>
}

extension CoreDataFetchProtocol {
    func publisher<T: NSManagedObject>(fetch request: NSFetchRequest<T>) -> CoreDataFetchResultsPublisher<T> {
        return CoreDataFetchResultsPublisher(request: request, context: viewContext)
    }
}

protocol CoreDataSaveProtocol {
    var viewContext: NSManagedObjectContext { get }
    func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher
}

extension CoreDataSaveProtocol {
    func publisher(save action: @escaping Action) -> CoreDataSaveModelPublisher {
        return CoreDataSaveModelPublisher(action: action, context: viewContext)
    }
}

protocol CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
    func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher
}

extension CoreDataDeleteModelPublishing {
    func publisher(delete request: NSFetchRequest<NSFetchRequestResult>) -> CoreDataDeleteModelPublisher {
        return CoreDataDeleteModelPublisher(delete: request, context: viewContext)
    }
}

protocol CoreDataManagerProtocol: EntityCreating,
                                    CoreDataFetchProtocol,
                                    CoreDataSaveProtocol,
                                    CoreDataDeleteModelPublishing {
    var viewContext: NSManagedObjectContext { get }
}

struct CoreDataManager: CoreDataManagerProtocol {

    var container: NSPersistentContainer

    static var preview: CoreDataManager = {
        let result = CoreDataManager(inMemory: false)
        return result
    }()

    var viewContext: NSManagedObjectContext {
        return self.container.viewContext
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoinsDB")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                /*
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
}
