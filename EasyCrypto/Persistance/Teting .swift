//
//  Teting .swift
//  EasyCrypto
//
//  Created by Mehran Kamalifard on 5/9/23.
//

import Foundation
import CoreData

extension NSManagedObjectModel {
    /// We use this static shared model to prevent errors like:
    /// `Failed to find a unique match for an NSEntityDescription to a managed object subclass`
    ///
    /// This error likely occurs when running tests with an in-memory store while the regular app launch loads a file backed store.
    static let sharedModel: NSManagedObjectModel = {
        let url = Bundle(for: PersistentContainer.self).url(forResource: "DataModel", withExtension: "momd")!
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: url) else {
            fatalError("Managed object model could not be created.")
        }
        return managedObjectModel
    }()
}
