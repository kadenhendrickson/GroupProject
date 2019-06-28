//
//  Ingredient.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class Ingredient: Codable {
    var name: String
    var measurementName: String
    var measurementQuantity: String
    
    init(name: String, measurementName: String, measurementQuantity: String) {
        self.name = name
        self.measurementName = measurementName
        self.measurementQuantity = measurementQuantity
    }
    var ingredientDict: [String:Any] {
        return [ "name" : name,
                 "measurementName" : measurementName,
                 "measurementQuantity" : measurementQuantity ]
    }
    
    convenience init?(dictionary: [String:Any]) {
        guard let name = dictionary["name"] as? String,
        let measurementName = dictionary["measurementName"] as? String,
            let measurementQuantity = dictionary["measurementQuantity"] as? String else {return nil}
        self.init(name: name, measurementName: measurementName, measurementQuantity: measurementQuantity)
    }
    
}


extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.measurementName == rhs.measurementName && rhs.measurementQuantity == lhs.measurementQuantity
    }
}
