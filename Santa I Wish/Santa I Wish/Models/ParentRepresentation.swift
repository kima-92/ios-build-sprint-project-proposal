//
//  ParentRepresentation.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ParentRepresentation: Codable {
    var name: String
    var children: [ChildRepresentation]?
}
