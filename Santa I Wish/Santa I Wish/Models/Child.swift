//
//  Child.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct Child {
    var name: String
    var photo: Data?
    var letters: [Letter]?
    var wishList: [Item]?
}

struct Letter {
    var note: String
    var date: Date
}

