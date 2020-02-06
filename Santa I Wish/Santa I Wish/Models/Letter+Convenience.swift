//
//  Letter+Convenience.swift
//  Santa I Wish
//
//  Created by brian vilchez on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation
import CoreData
extension Letter {
    
    var letterRepresentation: LetterRepresentation? {
        guard let letter = letter else { return nil}
        return LetterRepresentation(letter: letter)
    }
    
    convenience init(letter: String, child: Child, context: NSManagedObjectContext) {
        self.init(context:context)
        self.letter = letter
        self.child = child
    }
}
