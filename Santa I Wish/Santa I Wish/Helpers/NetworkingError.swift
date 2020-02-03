//
//  NetworkingError.swift
//  Santa I Wish
//
//  Created by macbook on 2/3/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case noData
    case serverError(Error)
    case unexpectedStatusCode(Int)
    case badDecode
}
