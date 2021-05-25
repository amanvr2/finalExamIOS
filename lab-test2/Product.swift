//
//  Product.swift
//  lab-test2
//
//  Created by Macbook on 5/23/21.
//

import Foundation

class Product {
    var id: Int
    var name: String
    var price: Int
    var description: String
    var provider: String
    
    init(id: Int, name: String, price: Int, description: String, provider: String) {
        
        self.id = id
        self.name = name
        self.price = price
        self.description = description
        self.provider = provider
    }
}
