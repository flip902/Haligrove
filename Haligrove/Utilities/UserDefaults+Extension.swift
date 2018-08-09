//
//  UserDefaults+Extension.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    static let favoriteKey = "favoriteKey"
    
    func savedProducts(for key: String) -> [Product] {
        guard let favoriteData = UserDefaults.standard.data(forKey: key) else { return [] }
        guard let favoritedProducts = NSKeyedUnarchiver.unarchiveObject(with: favoriteData) as? [Product] else { return [] }
        return favoritedProducts
    }
    
    func deleteProduct(product: Product, key: String) {
        let products = savedProducts(for: key)
        let filteredProducts = products.filter { (p) -> Bool in
            return p.name != product.name && p.src != product.src
        }
        let data = NSKeyedArchiver.archivedData(withRootObject: filteredProducts)
        UserDefaults.standard.set(data, forKey: key)
    }
}
