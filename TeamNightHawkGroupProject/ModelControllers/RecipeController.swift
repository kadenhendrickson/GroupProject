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
    
    //MARK: - Singleton
    static let shared = RecipeController()
    //MARK: - Current User
    var currentUser = UserController.shared.currentUser
    
    //MARK: - Properties
    lazy var db = Firestore.firestore()
   

    
    //MARK: - CRUD Functions
    
    func createRecipe(name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?, servingSize: String?, prepTime: String?) {
        guard let currentUser = currentUser else {return}
        var ingredientsDict: [Ingredient] = []
        for ingredient in ingredients {
            ingredientsDict.append(ingredient)
        }
        let recipe = Recipe(userReference: currentUser.userID, name: name, image: image, ingredients: ingredients, steps: steps, prepTime: prepTime ?? "--", servings: servingSize ?? "--", tags: tags)
        let recipeDictionary = recipe.dictionaryRepresentation
        db.collection("Recipes").document(recipe.recipeID).setData(recipeDictionary)
        db.collection("Users").document(currentUser.userID).updateData(["recipeRef" : FieldValue.arrayUnion([recipe.recipeID])])
        currentUser.recipesRef.append(recipe.recipeID)
    }
    
    func fetchSpecificRecipesWith(userReference: String, completion: @escaping ([Recipe]) -> Void) {
        let recipeReference = db.collection("Recipes")
        var recipesArray: [Recipe] = []
        
        recipeReference.whereField("userReference", isEqualTo: userReference).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching recipes: \(error.localizedDescription)")
                completion([])
                return
            }
            
            guard let documents = snapshot?.documents else {completion([]); return}
            for document in documents {
                let data = document.data()
                let theRecipe = Recipe(document: data)
                guard let recipe = theRecipe else {return}
                recipesArray.append(recipe)
            }
            completion(recipesArray)
            return
        }
    }

    func fetchExploreRecipes(blockedUsers: [String], completion: @escaping ([Recipe]) -> Void) {
        let recipeReference = db.collection("Recipes")
        var recipesArray: [Recipe] = []
        recipeReference.limit(to: 20).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching recipes: \(error.localizedDescription)")
            }
            guard let documents = snapshot?.documents else {completion([]); return}
            for document in documents {
                let data = document.data()
                let theRecipe = Recipe(document: data)
                guard let recipe = theRecipe else {return}
                if !blockedUsers.contains(recipe.userReference) {
                    recipesArray.append(recipe)
                }
            }
            completion(recipesArray)
        }
    }
    
    func fetchRecipesWith(recipeReferences: [String], completion: @escaping ([Recipe]) -> Void) {
        var recipesArray: [Recipe] = []
        let dispatchGroup = DispatchGroup()
        for recipeRef in recipeReferences {
            let recipeReference = db.collection("Recipes").document(recipeRef)
            dispatchGroup.enter()
            recipeReference.getDocument { (snapshot, error) in
                if let error = error {
                    print("There was an error fetching recipes: \(error.localizedDescription)")
                    dispatchGroup.leave()
                }
                guard let data = snapshot?.data() else {completion([]); return}
                let theRecipe = Recipe(document: data)
                guard let recipe = theRecipe else {return}
                recipesArray.append(recipe)
                dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(recipesArray)
        }
    }
    
    func deleteRecipeWith(recipeID: String) {
        guard let currentUser = currentUser else {return}
        db.collection("Recipes").document(recipeID).delete()
        db.collection("Users").document(currentUser.userID).updateData(["recipeRef" : FieldValue.arrayRemove([recipeID])])
        db.collection("Recipes").document(recipeID).getDocument { (snapshot, error) in
            if let error = error {
                print("there was an error fetching the recipe document : \(error.localizedDescription)")
            }
            guard let data = snapshot?.data(),
                    let usersWhoSavedRecipe = data["savedByUsers"] as? [String] else {return}
            for userRef in usersWhoSavedRecipe {
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    self.db.collection("Users").document(user.userID).updateData(["savedRecipeRefs" : FieldValue.arrayRemove([recipeID])])
                })
            }
        }
    }
    
    func updateRecipeWith(recipeID:String, name: String, image: UIImage, ingredients: [Ingredient], steps: [String]?, tags: [String]?, servingSize: String, prepTime: String) {
        var ingredientsDictArray: [[String:Any]] = []
        for ingredient in ingredients {
            ingredientsDictArray.append(ingredient.ingredientDict)
        }
        let recipeRef = db.collection("Recipes").document(recipeID)
        recipeRef.updateData([
            "name" : name,
            "image" : image.jpegData(compressionQuality: 0.1) ?? UIImage(),
            "servings" : servingSize,
            "prepTime" : prepTime,
            "ingredientsDict" : ingredientsDictArray,
            "steps" : steps ?? [String].self,
            "tags" : tags ?? [String].self ])
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

