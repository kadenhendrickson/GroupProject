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
    //database
    lazy var db = Firestore.firestore()
    //listener
    var recipeListener: ListenerRegistration!

    
    //CRUD
    
    func createRecipe(name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?, servingSize: String?, prepTime: String?) {
        guard let currentUser = currentUser else {return}
        let recipe = Recipe(userReference: currentUser.userID, name: name, image: image, ingredients: ingredients, steps: steps, prepTime: prepTime ?? "--", servings: servingSize ?? "--", tags: tags)
        let recipeDictionary = recipe.dictionaryRepresentation
        db.collection("Recipes").document(recipe.recipeID).setData(recipeDictionary)
        db.collection("Users").document(currentUser.userID).updateData(["recipeRef" : FieldValue.arrayUnion([recipe.recipeID])])
        currentUser.recipesRef.append(recipe.recipeID) 
    }
    
    func fetchSpecificRecipesWith(userReference: String, completion: @escaping ([Recipe]) -> Void) {
        let recipeReference = db.collection("Recipes")
        var recipesArray: [Recipe] = []
        recipeListener = recipeReference.whereField("userReference", isEqualTo: userReference).order(by: "userReference").addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("There was an error fetching recipes: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {completion([]); return}
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
    
    func fetchExploreRecipes(completion: @escaping ([Recipe]) -> Void) {
        let recipeReference = db.collection("Recipes")
        var recipesArray: [Recipe] = []
        recipeListener = recipeReference.order(by: "saveCount").limit(to: 20).addSnapshotListener({ (snapshot, error) in
            if let error = error {
                print("There was an error fetching recipes: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {completion([]); return}
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
    
    func fetchRecipesWith(recipeReferences: [String], completion: @escaping ([Recipe]) -> Void) {
        var recipesArray: [Recipe] = []
        for recipeRef in recipeReferences {
            let recipeReference = db.collection("Recipes").document(recipeRef)
            recipeListener = recipeReference.addSnapshotListener({ (snapshot, error) in
                if let error = error {
                    print("There was an error fetching recipes: \(error.localizedDescription)")
                }
                guard let data = snapshot?.data() else {completion([]); return}
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
            })
        }
        completion(recipesArray)
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
            "steps" : steps ?? "",
            "tags" : tags ?? "" ])
    }
    
    func addRecipeToUsersSavedList(WithRecipeID id: String) {
        guard let currentUser = currentUser else {return}
        
        currentUser.savedRecipeRefs.append(id)
        db.collection("Users").document(currentUser.userID).updateData(["savedRecipeRefs" : FieldValue.arrayUnion([id])])
        db.collection("Recipes").document(id).updateData(["savedByUsers" : FieldValue.arrayUnion([currentUser.userID])])
    }
    
    
    func deleteRecipeFromUsersSavedList(WithRecipeID id: String) {
        guard let currentUser = currentUser else {return}
        
        db.collection("Users").document(currentUser.userID).updateData(["savedRecipeRefs" : FieldValue.arrayRemove([id])])
        db.collection("Recipes").document(id).updateData(["savedByUsers" : FieldValue.arrayRemove([currentUser.userID])])
        
        guard let recipeIndexOnUser = currentUser.savedRecipeRefs.firstIndex(of: id) else {return}
        
        currentUser.savedRecipeRefs.remove(at: recipeIndexOnUser)
    }
}

