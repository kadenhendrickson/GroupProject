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
    
    
    //MARK: - Methods
    
    func chooseDummyUser(withName name: String) {
        
        guard let userID = getUserID(fromName: name) else { print("🍒 Can't find a user with name \(name). Printing from \(#function) \n In \(String(describing: MockData.self)) 🍒"); return}
        
        UserController.shared.currentUser = UserController.shared.users[userID]
        
        print("Current user ID is \(userID)")
        
    }
    
    private func getUserID(fromName name: String) -> String? {
        
        var dummyUser: User?
        
        for (_, user) in UserController.shared.users {
            if user.displayName == name {
                dummyUser = user
            }
        }
        
        guard let user = dummyUser else { print("🍒 Can't find a user with name \(name). Printing from \(#function) \n In \(String(describing: MockData.self)) 🍒"); return nil}
        
        return user.userID
    }
    
    func saveRamdomRecipesForUser(name: String, atQuantify qty: Int){
        let ID = getUserID(fromName: name)
        
        guard let userID = ID else { print("🍒 Can't find user ID for \(name). Printing from \(#function) \n In \(String(describing: MockData.self)) 🍒"); return }
        
        saveRamdomRecipesForUser(userID: userID, atQuantity: qty)
    }
    
    private func saveRamdomRecipesForUser(userID: String, atQuantity qty: Int){
        let recipeCount = RecipeController.shared.recipes.count
        let difference = recipeCount - qty
        
        guard difference > 0 else { print("🍒 Number of recipe to save for userID: \(userID) is larger than recipes exist in source of truth. Printing from \(#function) \n In \(String(describing: MockData.self)) 🍒"); return }
        let recipes = RecipeController.shared.recipes.shuffled().dropLast(difference)
        
        UserController.shared.users[userID]?.savedRecipeRefs = recipes.compactMap{ $0.value.recipeID }
    }
    
    
    func printDummyInfo() {
        
        printAllUsers()
//        printAllRecipes()

    }
    
    func loadUser(){

        // try loading from persistent, if after loading there are no dummy users, create them
        /* 1 */
        UserController.shared.users = UserController.shared.loadUsersFromPersistence()
        RecipeController.shared.recipes = RecipeController.shared.loadRecipeFromPersistentStore()
        
        /* 2 */
        guard UserController.shared.users.count < 1 else { return }
        
        /* 3 */
        createDummyData()
        
    }
    
    func resetMockData(){
        UserController.shared.users = [:]
        RecipeController.shared.recipes = [:]
        
        UserController.shared.saveUsersToPersistence()
        RecipeController.shared.saveRecipeToPersistentStore()
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
            
            print("\n\t\tIngredients:\n")

            for ingredient in recipe.ingredients {
                print("\t\t- \(ingredient.name) \t\t\t\(ingredient.measurementQuantity) \(ingredient.measurementName)\n")
            }
            
            print("\n\t\tSteps:\n")

            if let steps = recipe.steps {
                for step in steps {
                    print("\t\t- \(step)\n")
                }
            }
            
            print("\n\t\tTags:\n")
            
            if let tags = recipe.tags {
                for tag in tags {
                    print("\t\t- \(tag)\n")
                }
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
    
   
    // MARK: - Create User methods
    private func summonUser(withEmail email: String = "defaultmail@mail.com", displayName: String, biography: String = "I have bio graphy") {
        UserController.shared.createUser(withEmail: email, displayName: displayName, biography: biography, profileImage: UIImage(named: "duck")!)
        
        let currentUser = UserController.shared.currentUser!
        saveRamdomRecipesForUser(userID: currentUser.userID, atQuantity: 3)
    }
    
    private func summonLotsOfUsers(fromName names: String...){
        for name in names {
            summonUser(displayName: name)
            
            for _ in 1...3 {
                makeALotsOf(recipes: makeFood())
            }
        }
    }
    
    // MARK: - Create recipe methods
    private func makeALotsOf(recipes: String...){
        for recipe in recipes {
            createRecipe(name: recipe)
        }
    }
    
    private func createRecipe(name: String, steps: [String]? = nil){
        print("Making recipe for \(String(UserController.shared.currentUser!.displayName)), now we have \(RecipeController.shared.recipes.count) recipes.")
        let ingredients = getRamdonIngredients()
        let tags = getRamdomTags()
        let steps = getRandomSteps()
        RecipeController.shared.createRecipe(name: name, image: UIImage(named: "AnneCelery")!, ingredients: ingredients, steps: steps, tags: tags, servingSize: "2", prepTime: "10 minutes")
    }
    
    private func makeFood() -> String {
        let cookingMethod = ["braised", "fermented", "fried", "baked", "grilled", "boiled", "stir-fried", "space-freezed"]
        let foodPrefix = ["chicken", "meat", "chocolate", "strawberry", "celery", "sirloin", "salt", "cinnamon", "jalapeno", "carrot", "cheese", "pepper"]
        let foodSuffix = ["pizza", "sandwiches", "cake", "smoothie", "hotdog", "wings", "burger", "pie"]
        
        let randomPrefix = foodPrefix.randomElement()!
        let randomCookingMethod = cookingMethod.randomElement()!
        let randomSuffix = foodSuffix.randomElement()!
        
        return "\((randomCookingMethod).capitalized) \(randomPrefix) \(randomSuffix)"

    }
    
    
    // MARK: - Get Random Stuff
    private func getRamdonIngredients() -> [Ingredient]{
        let ingredients: [Ingredient] = [greenStuff, hardStuff, strawberry, whey, meat, milk, chicken, meat]
        return ingredients.shuffled().dropLast(5)
    }
    
    private func getRamdomTags() -> [String] {
        let tags = ["healthy", "comfortfood", "smoothie", "alienfood", "humanfood", "dessert"]
        return tags.shuffled().dropLast(4)
    }
    
    private func getRandomSteps() -> [String] {
        let steps = ["chop them", "bake", "fry", "ferment them", "toss them", "freez them"]
        return steps.shuffled().dropLast(4)
    }
    
}
