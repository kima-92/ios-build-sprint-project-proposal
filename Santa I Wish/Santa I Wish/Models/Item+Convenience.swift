//
//  Item+Convenience.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData

extension Item {
    
    convenience init(image: String, childNote: String, child: Child, context: NSManagedObjectContext) {
        self.init(context:context)
        self.image = image
        self.childNote = childNote
        self.child = child
    }
}
