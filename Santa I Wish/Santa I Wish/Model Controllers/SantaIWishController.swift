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
    
    
    func addChild(withName name: String, age: Int , context: NSManagedObjectContext) {
        
        let child = Child()
    }
    
    func createLetter(withLetter: String,context: NSManagedObjectContext) {}
    
    func addItemToWishList(itemName name: String, note: String ,context: NSManagedObjectContext ) {}
    
    func createParentProfile(withName name:String, email:String, context: NSManagedObjectContext) {}
}
