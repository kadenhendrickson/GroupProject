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
    
    let greenStuff = Ingredient(name: "chlorophyll", measurementName: "cups", measurementQuantity: "12")
    let hardStuff = Ingredient(name: "stalk", measurementName: "miligrams", measurementQuantity: "10000000")
    let whey = Ingredient(name: "whey", measurementName: "spoons", measurementQuantity: "2")
    let milk = Ingredient(name: "milk", measurementName: "cups", measurementQuantity: "1")
    let strawberry = Ingredient(name: "frozen strawberry", measurementName: "pieces", measurementQuantity: "3")
    let chicken = Ingredient(name: "chicken meat", measurementName: "chicken", measurementQuantity: "1/2")
    let meat = Ingredient(name: "meat", measurementName: "lbs", measurementQuantity: "5")
    
    
    func printDummyInfo() {
        
        printAllUsers()
        printAllRecipes()

    }
    
    func loadUser(){
        
        // RESET: uncomment 1, 4
        // DEFAULT: uncomment 2, 3, 4
        
        /* 1 */
         UserController.shared.users = [:]
        
        /* 2 */
        UserController.shared.users = UserController.shared.loadUsersFromPersistence()
        RecipeController.shared.recipes = RecipeController.shared.loadRecipeFromPersistentStore()

        
        /* 3 */
        guard UserController.shared.users.count < 1 else { return }
        
        
        /* 4 */
//        createDummyData()
        
    }
    

    // Private methods
    
    private func printAllUsers(){
        for (_, user) in UserController.shared.users {
            print("\n\n----------------")
            print("\(user.displayName)\n")
            print("\(user.biography ?? "No bio")")
            print("\(user.email)\n")
            print("\(user.userID)\n")
            
        }
    }
    
    private func printAllRecipes(){
        // Print all recipes
        print("-----RECIPES-----\n")
        for (_, recipe) in RecipeController.shared.recipes {
            print("\t\(recipe.name)\n")
            print("\t\(recipe.recipeID)\n")
            for ingredient in recipe.ingredients {
                print("\t\t- \(ingredient.name) \t\t\t\(ingredient.measurementQuantity) \(ingredient.measurementName)\n")
            }
            let creator = UserController.shared.users[recipe.userReference]
            print("\n\tCreated by 🎖 \(creator!.displayName) 🎖\n")
            print("--------------------------------------------")
        }
    }
    
    private func printRecipesOf(user: User){
        for recipeRef in user.recipesRef {
            guard let recipe = RecipeController.shared.recipes[recipeRef] else { return }
            print("\t- \(recipe.name)\n")
                for ingredient in recipe.ingredients {
                    print("\t\t\(ingredient.name) \t\(ingredient.measurementQuantity) \(ingredient.measurementName)\n")
                }
        }
    }
    
    private func createDummyData() {
        
        // MARK: - Users Creation

        UserController.shared.createUser(withEmail: "kadenhendrickson4@gmail.com", displayName: "kadenHendrickson", biography: "i am a student", profileImage: UIImage(named: "ProfileCelery")!)
        
        RecipeController.shared.createRecipe(name: "Celery", image: UIImage(named: "AnneCelery")!, ingredients: [greenStuff, hardStuff], steps: ["first, wash it.", "second, chop it.", "third, chomp it.", "fourth, poop it."], tags: ["healthy", "crunchy", "green"], servingSize: "2", prepTime: "10 minutes")
        
        makeALotsOf(recipes: "smoothies", "pizza", "hummus")

        UserController.shared.createUser(withEmail: "anneishungry@gmail.com", displayName: "annedog", biography: "computer programmer", profileImage: UIImage(named: "ProfileCelery")!)
        
        makeALotsOf(recipes: "ice cream", "pasta", "fried rice")
        
        UserController.shared.createUser(withEmail: "shanehasabigbeard@gmail.com", displayName: "bigBeardShane", biography: "I have a big beard", profileImage: UIImage(named: "ProfileCelery")!)
        
        makeALotsOf(recipes: "chicken alfredo", "taco", "steak", "hot dog")
        
        summonLotsOfUsers(fromName: "Will", "Brian", "Winston", "Kyle", "William", "Haley", "Leah", "Austin", "Dustin", "Jaden", "Lo")

    }
    
   
    // Create Users
    private func summonUser(withEmail email: String = "defaultmail@mail.com", displayName: String, biography: String = "") {
        UserController.shared.createUser(withEmail: email, displayName: displayName, biography: biography, profileImage: nil)
    }
    
    private func summonLotsOfUsers(fromName names: String...){
        for name in names {
            summonUser(displayName: name)
            
            for _ in 1...3 {
                makeALotsOf(recipes: makeFood())
            }
        }
    }
    
    // Create recipes
    private func makeALotsOf(recipes: String...){
        for recipe in recipes {
            createRecipe(name: recipe)
        }
    }
    
    private func createRecipe(name: String, steps: [String]? = nil){
        print("Making recipe for \(String(UserController.shared.currentUser!.displayName)), now we have \(RecipeController.shared.recipes.count) recipes.")
        let ingredients = getRamdonIngredients()
        let tags = getRamdomTags()
        RecipeController.shared.createRecipe(name: name, image: UIImage(named: "AnneCelery")!, ingredients: ingredients, steps: steps, tags: tags, servingSize: "2", prepTime: "10 minutes")
    }
    
    private func makeFood() -> String {
        let foodPrefix = ["chicken", "meat", "chocolate", "strawberry", "celery", "sirloin", "salt", "cinnamon", "jalapeno", "carrot"]
        let foodSuffix = ["pizza", "sandwiches", "cake", "smoothie", "hotdog", "wings", "burger", "pie"]
        
        let randomPrefix = foodPrefix.randomElement()!
        let randomSuffix = foodSuffix.randomElement()!
        
        return "\(randomPrefix) \(randomSuffix)"

    }
    
    private func getRamdonIngredients() -> [Ingredient]{
        let ingredients: [Ingredient] = [greenStuff, hardStuff, strawberry, whey, meat, milk, chicken, meat]
        return ingredients.shuffled().dropLast(5)
    }
    
    private func getRamdomTags() -> [String] {
        let tags = ["healthy", "comfortfood", "smoothie", "alienfood", "humanfood", "dessert"]
        return tags.shuffled().dropLast(4)
    }
    
}
