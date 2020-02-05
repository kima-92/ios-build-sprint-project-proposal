//
//  SantaIWishController.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

class SantaIWishController {
    
@discardableResult func addChild(withName name: String, age: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Child {
        
        let child = Child(name: name, age: String(age), context: context)
        CoreDataStack.shared.saveToPersistentStore()
        print(child)
        return child
    }
    
func createLetter(withLetter: String, context: NSManagedObjectContext) {}
    
func addItemToWishList(itemName name: String, note: String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext ) {}
    
func createParentProfile(with name:String, email:String, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let parent = Parent(name: name, email: email, context: context)
        CoreDataStack.shared.saveToPersistentStore()
        print(parent)
    }
}
