//
//  Product.swift
//  Haligrove
//
//  Created by Phillip Carlino on 2018-07-26.
//  Copyright © 2018 Phillip Carlino. All rights reserved.
//

import Foundation

enum StrainType: String {
    case indica = "Indica"
    case sativa = "Sativa"
    case hybrid = "Hybrid"
}

class Product: NSObject, Decodable, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name ?? "", forKey: "productName")
        aCoder.encode(src ?? "", forKey: "imageSource")
        aCoder.encode(type ?? "", forKey: "productType")
        aCoder.encode(pricePerGram ?? "", forKey: "pricePerGram")
        aCoder.encode(priceForFive ?? "", forKey: "priceForFive")
        aCoder.encode(pricePerOunce ?? "", forKey: "pricePerOz")
        aCoder.encode(salePricePerGram ?? "", forKey: "salePricePerGram")
        aCoder.encode(salePriceForFive ?? "", forKey: "salePriceForFive")
        aCoder.encode(salePricePerOunce ?? "", forKey: "salePricePerOunce")
        aCoder.encode(productDescription ?? "", forKey: "description")
        aCoder.encode(isFavorite ?? "", forKey: "favorite")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObject(forKey: "productName") as? String
        self.src = aDecoder.decodeObject(forKey: "imageSource") as? String
        self.type = aDecoder.decodeObject(forKey: "productType") as? String
        self.pricePerGram = aDecoder.decodeObject(forKey: "pricePerGram") as? Float
        self.priceForFive = aDecoder.decodeObject(forKey: "priceForFive") as? Float
        self.pricePerOunce = aDecoder.decodeObject(forKey: "pricePerOz") as? Float
        self.salePricePerGram = aDecoder.decodeObject(forKey: "salePricePerGram") as? Float
        self.salePriceForFive = aDecoder.decodeObject(forKey: "salePriceForFive") as? Float
        self.salePricePerOunce = aDecoder.decodeObject(forKey: "salePricePerOunce") as? Float
        self.productDescription = aDecoder.decodeObject(forKey: "description") as? String
        self.isFavorite = aDecoder.decodeObject(forKey: "favorite") as? Bool
    }
    
    var id: String?
    var name: String?
    var src: String?
    var type: String?
    var category: String?
    var isNew: String?
    var pricePerGram: Float?
    var priceForFive: Float?
    var pricePerOunce: Float?
    var sale: String?
    var salePricePerGram: Float?
    var salePriceForFive: Float?
    var salePricePerOunce: Float?
    var productDescription: String?
    var inventory: String?
    var THC: Int?
    var taste: Int?
    var aroma: Int?
    var pain: Int?
    var insomnia: Int?
    var appetite: Int?
    var overall: Int?
    var soldOut: String?
    var isFavorite: Bool?
}

