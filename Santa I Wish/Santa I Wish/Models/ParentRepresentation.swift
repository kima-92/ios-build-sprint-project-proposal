//
//  ParentRepresentation.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ParentRepresentation: Codable {
    let id: String
    var name: String
    var children: [ChildRepresentation]?
    var holidayBudget: Double?
    var password: String?
    var passCode: String?
}
