//
//  RecipeController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import Firebase

class RecipeController {
    //SharedInstance
    static let shared = RecipeController()
    //current user
    var currentUser = UserController.shared.currentUser
    //sourceoftruth
    //var recipes: [String : Recipe] = [:]
    //var recipes: [Recipe] = []
    //database
    let db = Firestore.firestore()
    //listener
    var recipeListener: ListenerRegistration!

    
    //CRUD
    
    func createRecipe(name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?, servingSize: String?, prepTime: String?) {
        guard let currentUser = currentUser else {return}
        let recipe = Recipe(userReference: currentUser.userID, name: name, image: image, ingredients: ingredients, steps: steps, prepTime: prepTime ?? "--", servings: servingSize ?? "--", tags: tags)
        let recipeRef = db.collection("Recipes")
        let recipeDictionary = recipe.dictionaryRepresentation
        recipeRef.document(recipe.recipeID).setData(recipeDictionary)
        currentUser.recipesRef.append(recipe.recipeID)
    }
    
    func fetchRecipes(completion: @escaping ([Recipe]) -> Void) {
        let recipeReference = db.collection("Recipes")
        var recipesArray: [Recipe] = []
        recipeListener = recipeReference.order(by: "userReference").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("There was an error fetching recipes: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {return; completion([])}
            for document in documents {
                let data = document.data()
                let userReference = data["userReference"] as? String ?? ""
                let name = data["name"] as? String ?? ""
                let image = data["image"] as? Data?
                let ingredients = data["ingredients"] as? [Ingredient] ?? []
                let steps = data["steps"] as? [String] ?? [""]
                let prepTime = data["prepTime"] as? String ?? ""
                let servings = data["servings"] as? String ?? ""
                let tags = data["tags"] as? [String] ?? []
                let recipe = Recipe(userReference: userReference, name: name, image: UIImage(data: image!!), ingredients: ingredients, steps: steps, prepTime: prepTime, servings: servings, tags: tags)
                recipesArray.append(recipe)
            }
            completion(recipesArray)
        })
    }
    
    
    func deleteRecipeWith(recipeID: String) {
        db.collection("Recipes").document(recipeID).delete()
    }
    
    func updateRecipeWith(recipeID:String, name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?) {
        let recipeRef = db.collection("Recipes").document(recipeID)
        recipeRef.setData([
            "name" : name,
            "image" : image,
            "ingredients" : ingredients,
            "steps" : steps,
            "tags" : tags ])
    }
    
    func addRecipeToUsersSavedList(WithRecipeID id: String) {
        guard let currentUser = currentUser else {return}
        
        #warning("access current users spot on firebase and remove remotely")
        currentUser.savedRecipeRefs.append(id)
        db.collection("Recipes").document(id).updateData(["savedByUsers" : FieldValue.arrayUnion([id])])
    }
    #warning("fix after you build users top level")
    func deleteRecipeFromUsersSavedList(WithRecipeID id: String) {
        let recipeRef = db.collection("Recipes").document(id)
        guard let recipeIndexOnUser = currentUser?.savedRecipeRefs.firstIndex(of: id),
                let currentUser = currentUser,
                let recipe = recipes[id],
                let userIndexOnRecipe = recipe.savedByUsers.firstIndex(of: currentUser.userID) else {return}
        currentUser.savedRecipeRefs.remove(at: recipeIndexOnUser)
        recipe.savedByUsers.remove(at: userIndexOnRecipe)
    }
}

