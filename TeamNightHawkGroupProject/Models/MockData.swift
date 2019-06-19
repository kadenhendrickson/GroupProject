//
//  MockData.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class MockData {
    
     static let shared = MockData()
    
    func createDummyData() {
        
       
        
        UserController.shared.createUser(withEmail: "kadenhendrickson4@gmail.com", displayName: "kadenHendrickson", biography: "i am a student", profileImage: nil)
        let greenStuff = Ingredient(name: "chlorophyll", measurementName: "cups", measurementQuantity: "12")
        let hardStuff = Ingredient(name: "stalk", measurementName: "miligrams", measurementQuantity: "10000000")
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        
        
        UserController.shared.createUser(withEmail: "anneiscool@gmail.com", displayName: "annedog", biography: "computer programmer", profileImage: nil)
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
     
        
        UserController.shared.createUser(withEmail: "shanehasabigbeard@gmail.com", displayName: "bigBeardShane", biography: "I have a big beard", profileImage: nil)
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        RecipeController.shared.createRecipe(name: "Pizza", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"])
        printDummyInfo()
        
    }
    
   
    func printDummyInfo() {
        for (id, user) in UserController.shared.users {
            print(user.displayName)
            print(user.email)
            print("-----RECIPES-----")
            for (_, recipe) in RecipeController.shared.recipes {
                if recipe.userReference == id {
                    print(recipe.name)
                    print(recipe.ingredients.description)
                }
            }
        }
    }
    
    
    
}
