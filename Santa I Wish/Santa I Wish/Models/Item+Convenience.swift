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
    
    var itemRepresentation: ItemRepresentation? {
        guard let childNote = childNote, let name = name  else { return nil }
        return ItemRepresentation(childNote: childNote,name: name)
    }
    
    convenience init(image: String, childNote: String, name: String, context: NSManagedObjectContext) {
        self.init(context:context)
        self.image = image
        self.childNote = childNote
        self.child = child
        self.name = name
    }
}
