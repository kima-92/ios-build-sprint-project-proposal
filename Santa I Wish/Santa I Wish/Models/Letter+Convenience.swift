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
        guard let note = note,
            let title = title else { return nil}
        return LetterRepresentation(note: note, title: title)
    }
    
    convenience init(note: String, child: Child, title: String, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.note = note
        self.child = child
        self.title = title
    }
}
