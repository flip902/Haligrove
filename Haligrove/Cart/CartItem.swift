//
//  CartItem.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import Foundation

struct CartItem: Equatable, Decodable {
    let id: Int
    let name: String
    let qty: Int
    let price: Float
    let imageUrl: String?
    let description: String?
    
    static func ==(lhs: CartItem, rhs: CartItem) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.qty == rhs.qty &&
            lhs.price == rhs.price
    }
}
