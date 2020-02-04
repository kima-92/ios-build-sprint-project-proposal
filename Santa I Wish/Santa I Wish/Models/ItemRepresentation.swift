//
//  ItemRepresentation.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ItemRepresentation: Codable {
    let id: String
    var name: String
    var letter: String?
    var childNotes: String?
    var hasBeenBought: Bool?
    var image: Data?
    var store: String?
    var priceS: Double?
}
