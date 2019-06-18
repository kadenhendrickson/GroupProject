//
//  Ingredient.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class Ingredient: Codable {
    let name: String
    let measurement: String
    
    init(name: String, measurement: String) {
        self.name = name
        self.measurement = measurement
    }
}

extension Ingredient: Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs.name == rhs.name && lhs.measurement == rhs.measurement
    }
}
