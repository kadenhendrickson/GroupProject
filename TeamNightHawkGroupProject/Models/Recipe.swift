//
//  Recipe.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class Recipe {
    let userReference: String
    let recipeID: String
    let name: String
    var image: UIImage?
    let ingredients: [Ingredient]
    let steps: [String]?
    let prepTime: String?
    let servings: Int?
    let tags: [String]?
    let savedByUsers: [String]
    var saveCount: Int {
        return savedByUsers.count
    }
    
    init(userReference: String, recipeID: String, name: String, image: UIImage?, ingredients: [Ingredient], steps: [String]?, prepTime: String?, servings: Int?, tags: [String]?, savedByUsers: [String] = []) {
        self.userReference = userReference
        self.recipeID = recipeID
        self.name = name
        self.ingredients = ingredients
        self.steps = steps
        self.prepTime = prepTime
        self.servings = servings
        self.tags = tags
        self.savedByUsers = savedByUsers
        self.image = image
    }
    
    
}
