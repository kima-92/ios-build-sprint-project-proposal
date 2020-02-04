//
//  ChildRepresentation.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ChildRepresentation: Codable {
    let id: String
    var name: String
    var letter: String?
    var photo: Data?
//    var wishList: [Item]?
}
