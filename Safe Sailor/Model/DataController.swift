//
//  DataController.swift
//  Safe Sailor
//
//  Created by Dimopoulos Stavros tou Athanasiou on 12/2/20.
//  Copyright © 2020 Dimopoulos Stavros tou Athanasiou. All rights reserved.
//

import Foundation
import CoreData
class DataController {
    let persistentContainer:NSPersistentContainer
    init(modelName:String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    var viewContext:NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    func load(completion:(()->Void)? = nil) {
        persistentContainer.loadPersistentStores {storeDescription, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
}
