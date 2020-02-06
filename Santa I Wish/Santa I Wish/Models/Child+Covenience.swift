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
    
    var childRepresentation: ChildRepresentation? {
        guard let name = name, let age = age, let letters = letters,
            let items = items else { return nil }
        var letterRepresentation = [LetterRepresentation]()
        var itemRepresentation = [ItemRepresentation]()
        for case let letter as Letter in letters  {
            guard let letterRep = letter.letterRepresentation else {return nil }
            letterRepresentation.append(letterRep)
        }
        
        for case let item as Item in items {
            guard let itemRep = item.itemRepresentation else { return nil }
            itemRepresentation.append(itemRep)
        }
        return ChildRepresentation(name: name, age: age, letters:letterRepresentation, items: itemRepresentation)
    }
    
    convenience init(name: String, age: String, letters: NSSet = [], items: NSSet = [], context: NSManagedObjectContext) {
        self.init(context:context)
        self.name = name
        self.age = age
        self.letters = letters
        self.items = items
    }
}
