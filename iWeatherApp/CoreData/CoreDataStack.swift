//
//  CoreDataStack.swift
//  iWeatherApp
//
//  Created by Michael on 18.02.2018.
//  Copyright © 2018 Michael. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer {
        let container = NSPersistentContainer(name: "Cities")
        container.loadPersistentStores { (_, error) in
            guard error == nil else {
                log.error("Error loading persistent store: \(error!)")
                return
            }
        }
        
        return container
    }
    
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
