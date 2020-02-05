//
//  Child+Covenience.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Child {
    
    convenience init(name: String, age: String, letters: NSSet , parent: Parent, items: NSSet,context: NSManagedObjectContext) {
        self.init(context:context)
        self.name = name
        self.age = age
        self.letters = letters
        self.parent = parent
        self.items = items
    }
}
