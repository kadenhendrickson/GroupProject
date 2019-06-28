//
//  Ingredient.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class Ingredient  {
    var name: String
    var measurementName: String
    var measurementQuantity: String
    
    init(name: String, measurementName: String, measurementQuantity: String) {
        self.name = name
        self.measurementName = measurementName
        self.measurementQuantity = measurementQuantity
    }
    
    var ingredientDictionary: [String : Any] {
        return ["name" : name,
            "measurementName" : measurementName,
            "measurementQuantity" : measurementQuantity]
    }
}

extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.measurementName == rhs.measurementName && lhs.measurementQuantity == rhs.measurementQuantity
    }
}
