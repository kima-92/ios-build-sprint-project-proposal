//
//  Parent+Convenience.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Parent {
    
    convenience init(name: String, email:String, children: NSSet = [], context: NSManagedObjectContext) {
        self.init(context:context)
        self.name = name
        self.email = email
        self.children = children
    }
}
