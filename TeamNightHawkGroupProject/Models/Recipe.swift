//
//  Recipe.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class Recipe: Codable {
    let userReference: String
    let recipeID: String
    var name: String
    var image: Data?
    var ingredients: [Ingredient]
    var steps: [String]?
    var prepTime: String
    var servings: String
    var tags: [String]?
    var savedByUsers: [String]
    var saveCount: Int {
        return savedByUsers.count
    }
    //changed image to 'Data?' from 'UIImage?' to test local Persistence. also changed self.image = image to self.image = image.png?Data()
    init(userReference: String, recipeID: String = UUID().uuidString, name: String, image: UIImage?, ingredients: [Ingredient], steps: [String]?, prepTime: String, servings: String, tags: [String]?, savedByUsers: [String] = []) {
        self.userReference = userReference
        self.recipeID = recipeID
        self.name = name
        self.ingredients = ingredients
        self.steps = steps
        self.prepTime = prepTime
        self.servings = servings
        self.tags = tags
        self.savedByUsers = savedByUsers
        self.image = image?.jpegData(compressionQuality: 0.5)
    }
    
    var dictionaryRepresentation: [String:Any] {
        return ["userReference": userReference,
                "recipeID" : recipeID,
                "image" : image,
                "name" : name,
                "ingredients" : ingredients,
                "steps" : steps,
                "prepTime" : prepTime,
                "servings" : servings,
                "tags" : tags,
                "savedByUsers" : savedByUsers,
                "saveCount" : saveCount
        ]
    }
}


extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.recipeID == rhs.recipeID
    }
    
   
}
