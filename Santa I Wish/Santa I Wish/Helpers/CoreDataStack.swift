//
//  CoreDataStack.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    static let shared = CoreDataStack()
    
    // Set up a persistent container
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SantaIWish")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        
        // Automatically merging changes from parent
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    // Create easy access to the moc (managed object context)
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) {
        context.performAndWait {
            do {
                try context.save()
            } catch {
                NSLog("Error saving context: \(error)")
                context.reset()
            }
        }
    }
    
    func saveToPersistentStore() {
        do {
            try mainContext.save()
        } catch {
            NSLog("Error saving context: \(error)")
            mainContext.reset()
        }
    }
}
