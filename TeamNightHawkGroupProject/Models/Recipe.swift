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
    static let ingredientsDictKey = "ingredientsDict"
    static let timestampKey = "timestamp"
}

class Recipe {
    let userReference: String
    let recipeID: String
    var name: String
    var image: Data?
    var ingredients: [Ingredient]
    var ingredientsDict: [[String:Any]] {
        var array: [[String:Any]] = []
        for ingredient in ingredients {
            array.append(ingredient.ingredientDict)
        }
        return array
    }
    var steps: [String]?
    var prepTime: String
    var servings: String
    var tags: [String]?
    var savedByUsers: [String]
    var saveCount: Int {
        return savedByUsers.count
    }
    var timestamp: Date
    init(userReference: String, recipeID: String = UUID().uuidString, name: String, image: UIImage?, ingredients: [Ingredient] = [], steps: [String]?, prepTime: String, servings: String, tags: [String]?, savedByUsers: [String] = [], timestamp: Date = Date()) {

        self.userReference = userReference
        self.recipeID = recipeID
        self.name = name
        self.steps = steps
        self.prepTime = prepTime
        self.ingredients = ingredients
        self.servings = servings
        self.tags = tags
        self.savedByUsers = savedByUsers
        self.image = image?.jpegData(compressionQuality: 0.1)
        self.timestamp = timestamp
    }
    
    // Init from firestore's document
    convenience init?(document: [String: Any]) {
         guard let userReference = document[RecipeKeys.userReferenceKey] as? String,
            let recipeId = document[RecipeKeys.recipeIDKey] as? String,
            let name = document[RecipeKeys.nameKey] as? String,
            let image = document[RecipeKeys.imageKey] as? Data?,

            let steps = document[RecipeKeys.stepsKey] as? [String],
            let prepTime = document[RecipeKeys.prepTimeKey] as? String,
            let servings = document[RecipeKeys.servingsKey] as? String,
            let tags = document[RecipeKeys.tagsKey] as? [String],
            let savedByUsers = document[RecipeKeys.savedByUsersKey] as? [String],
            let timestampAsTimeStamp = document[RecipeKeys.timestampKey] as? Timestamp else  {
                print("🍒 Failed to create a recipe from snapshot. Printing from \(#function) \n In \(String(describing: Recipe.self)) 🍒")
                return nil
        }
        let timestamp = timestampAsTimeStamp.dateValue()
        var ingredients: [Ingredient] = []
        if let ingredientsDict = document[RecipeKeys.ingredientsDictKey] as? [[String:Any]] {
            for ingredient in ingredientsDict {
                if let ingredient = Ingredient(dictionary: ingredient) {
                    ingredients.append(ingredient)
                }
            }
        }
    
        self.init(userReference: userReference, recipeID: recipeId, name: name, image: UIImage(data: image!) ?? UIImage(named: "AnneCelery"), ingredients: ingredients, steps: steps, prepTime: prepTime, servings: servings, tags: tags, savedByUsers: savedByUsers, timestamp: timestamp )
    }
    
    var dictionaryRepresentation: [String:Any] {
        return ["userReference": userReference,
                "recipeID" : recipeID,
                "image" : image ?? Data(),
                "name" : name,
                "ingredientsDict" : ingredientsDict,
                "steps" : steps ?? [String].self,
                "prepTime" : prepTime,
                "servings" : servings,
                "tags" : tags ?? [String].self,
                "savedByUsers" : savedByUsers,
                "saveCount" : saveCount,
                "timestamp" : timestamp
        ]
    }
}

extension Recipe: Equatable {
    static func == (lhs: Recipe, rhs: Recipe) -> Bool {
        return lhs.recipeID == rhs.recipeID
    }
}
