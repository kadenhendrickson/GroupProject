//
//  RecipeController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class RecipeController {
    //SharedInstance
    static let shared = RecipeController()
    //current user
    var currentUser = UserController.shared.currentUser
    //sourceoftruth
    var recipes: [String : Recipe] = [:]

    
    //CRUD
    func createRecipe(name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?, servingSize: String?, prepTime: String?) {
        guard let currentUser = currentUser else {return}
        let recipe = Recipe(userReference: currentUser.userID, name: name, image: image, ingredients: ingredients, steps: steps, prepTime: prepTime ?? "--", servings: servingSize ?? "--", tags: tags)
        recipes[recipe.recipeID] = recipe
        saveRecipeToPersistentStore()
    }
    
    func deleteRecipeWith(id: String) {
        recipes.removeValue(forKey: id)
        saveRecipeToPersistentStore()
    }
    
    func updateRecipeWith(id:String, name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?) {
        guard let recipe = recipes[id] else {return}
        recipe.name = name
        recipe.image = image.pngData() // This needs to be a UIImage but idk how to convert that bitch so its data now
        recipe.ingredients = ingredients
        recipe.steps = steps
        recipe.tags = tags
        saveRecipeToPersistentStore()
    }
    
    func addRecipeToUsersSavedList(WithRecipeID id: String) {
        guard let currentUser = currentUser,
                let recipe = recipes[id] else {return}
        currentUser.savedRecipeRefs.append(id)
        recipe.savedByUsers.append(currentUser.userID)
    }
    
    func deleteRecipeFromUsersSavedList(WithRecipeID id: String) {
        guard let recipeIndexOnUser = currentUser?.savedRecipeRefs.firstIndex(of: id),
                let currentUser = currentUser,
                let recipe = recipes[id],
                let userIndexOnRecipe = recipe.savedByUsers.firstIndex(of: currentUser.userID) else {return}
        currentUser.savedRecipeRefs.remove(at: recipeIndexOnUser)
        recipe.savedByUsers.remove(at: userIndexOnRecipe)
    }
}

extension RecipeController {
    //Add local Persistence
    private func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let filename = "TeamNightHawkGroupProject.json"
        let documentaryDirectoryUrl = urls[0].appendingPathComponent(filename)
        return documentaryDirectoryUrl
    }
    
    func saveRecipeToPersistentStore() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(recipes)
            let url = fileURL()
            try data.write(to: url)
        } catch {
            print("There was an error saving recipes \(error.localizedDescription)")
        }
    }
    
    func loadRecipeFromPersistentStore() -> [String : Recipe] {
        let jsonDecoder = JSONDecoder()
        do {
            let url = fileURL()
            let data = try Data(contentsOf: url)
            let recipes = try jsonDecoder.decode([String : Recipe].self, from: data)
            return recipes
        } catch {
            print("There was an error loading data \(error.localizedDescription)")
            return [:]
        }
    }
}
