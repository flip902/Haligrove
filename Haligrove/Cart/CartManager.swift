//
//  CartManager.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import Foundation

class CartManager: NSObject {
    
    private var itemsArray: [CartItem] = []
    
    static let instance: CartManager = {
        let oneInstance = CartManager()
        return oneInstance
    }()
    
    func addItem(item: CartItem) {
        itemsArray.append(item)
    }
    
    func removeItem(item: CartItem) -> Bool {
        if let index = itemsArray.index(where: { $0 == item }) {
            self.itemsArray.remove(at: index)
            return true
        }
        return false
    }
    
    func totalPriceInCart() -> Float {
        var totalPrice: Float = 0
        for item in itemsArray {
            totalPrice += Float(item.price)
        }
        return totalPrice
    }
    
    func itemAtIndexPath(indexPath: IndexPath) -> CartItem {
        return itemsArray[indexPath.row]
    }
    
    func numberOfItemsInCart() -> Int {
        return itemsArray.count
    }
    
    func clearCart() {
        itemsArray.removeAll(keepingCapacity: false)
    }
    
    func isProductInCart(product: Product) -> Bool {
        for item in itemsArray {
            if product.name == item.name {
                return true
            }
        }
        return false
    }
    
}
