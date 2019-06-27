//
//  Recipe.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import Firebase

struct RecipeKeys {
    static let userReferenceKey = "userReference"
    static let recipeIDKey = "recipeID"
    static let nameKey = "name"
    static let imageKey = "image"
    static let ingredientsKey = "ingredients"
    static let stepsKey = "steps"
    static let prepTimeKey = "prepTime"
    static let servingsKey = "servings"
    static let tagsKey = "tags"
    static let savedByUsersKey = "savedByUsers"
    static let saveCountKey = "saveCount"
}

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
        self.image = image?.jpegData(compressionQuality: 0.1)
    }
    
    // Init from firestore's document
    convenience init?(document: [String: Any]) {
         guard let userReference = document[RecipeKeys.userReferenceKey] as? String,
            let recipeId = document[RecipeKeys.recipeIDKey] as? String,
            let name = document[RecipeKeys.nameKey] as? String,
            let image = document[RecipeKeys.imageKey] as? Data?,
            let ingredients = document[RecipeKeys.ingredientsKey] as? [Ingredient],
            let steps = document[RecipeKeys.stepsKey] as? [String],
            let prepTime = document[RecipeKeys.prepTimeKey] as? String,
            let servings = document[RecipeKeys.servingsKey] as? String,
            let tags = document[RecipeKeys.tagsKey] as? [String],
            let savedByUsers = document[RecipeKeys.savedByUsersKey] as? [String] else {
                print("🍒 Failed to create a recipe from snapshot. Printing from \(#function) \n In \(String(describing: Recipe.self)) 🍒")
                return nil
        }
        
        self.init(userReference: userReference, recipeID: recipeId, name: name, image: UIImage(data: image!) ?? UIImage(named: "AnneCelery"), ingredients: ingredients, steps: steps, prepTime: prepTime, servings: servings, tags: tags, savedByUsers: savedByUsers)
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
