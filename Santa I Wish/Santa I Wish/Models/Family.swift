//
//  Family.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct  Family {
    var id: String
    var parent: Parent?
    var children: [Child] // children = Parent.children
    var password: String
}
