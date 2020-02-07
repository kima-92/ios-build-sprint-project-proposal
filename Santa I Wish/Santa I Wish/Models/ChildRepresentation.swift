//
//  ChildRepresentation.swift
//  Santa I Wish
//
//  Created by macbook on 2/4/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

struct ChildRepresentation: Codable {
    let name: String
    let age: String
    let letters: [LetterRepresentation]
    let items: [ItemRepresentation]
    
    init(name: String, age: String, letters: [LetterRepresentation], items: [ItemRepresentation] ) {
           self.name = name
           self.age = age
           self.letters = letters
           self.items = items
    }
    
    init(from decoder: Decoder) throws {
           let container = try decoder.container(keyedBy: CodingKeys.self)
           
           let name = try container.decode(String.self, forKey: .name)
           let age = try container.decode(String.self, forKey: .age)
           let letters = try container.decodeIfPresent([String:LetterRepresentation].self, forKey: .letters)?.map({$0.value}) ?? []
           let items = try container.decodeIfPresent([String:ItemRepresentation].self, forKey: .items)?.map({$0.value}) ?? []
        
           self.name = name
           self.age = age
           self.letters = letters
           self.items = items
       }

}
