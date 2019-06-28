//
//  SavedRecipesTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class SavedRecipesTableViewController: UITableViewController {

    //MARK: - Properties
    var recipesIDs: [String] = []
    
    // somehow fetching here makes user and recipe swaps, for now store them as dictionary to make it work
    
    // dictionaries of recipekey : recipe
    var recipesList: [String: Recipe] = [:]
    
    // dictionaries of recipekey : user
    var usersList: [String: User] = [:] {
        didSet {
            print("😝😝😝Users was set😝😝😝")
            print(self.usersList.count)
            
            guard usersList.count > 0,
                usersList.count == recipesIDs.count else {return}
            tableView.reloadData()
        }
    }
    

    
//    var recipesList: [Recipe]? {
//        didSet{
//            print("🌎🌎🌎Recipes set!😝😝😝")
//            print(self.recipesList?.count)
//        }
//    }
//
//    var usersList: [User]? {
//        didSet {
//            print("😝😝😝Users was set😝😝😝")
//            print(self.usersList?.count)
//            tableView.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Recipes"

        loadUsersAndRecipes()
    }
    

    func loadUsersAndRecipes() {
        
        guard let recipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return}
        
        self.recipesIDs = recipeRefs

        RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs) { (recipes) in
            
            guard recipes.count > 0 else {return}
            
            for recipe in recipes {
                self.recipesList[recipe.recipeID] = recipe
                
                let userRef = recipe.userReference
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    self.usersList[recipe.recipeID] = user
                })
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesIDs.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell
            else { print("🍒 I'm failing your cell deque because I'm a guard statement. I might deque other cells just fine but I'm failing this one. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return UITableViewCell() }
        
        let dicKey = self.recipesIDs[indexPath.row]
        let recipe = self.recipesList[dicKey]
        let user = self.usersList[dicKey]
        
        // User must get assign into cell before recipe. Or you will experience traumatic debugging event.
        cell.user = user
        cell.recipe = recipe
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "fromSavedToRecipeDVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? RecipeDetailTableViewController,
                let cell = tableView.cellForRow(at: indexPath),
                let recipeCell = cell as? SavedRecipeTableViewCell,
                let recipe = recipeCell.recipe,
                let user = recipeCell.user
                else { print("🍒 Failed to meet all the conditions for segueing to Recipe's detail view. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return }
            
            destinationVC.recipe = recipe
            destinationVC.navigationTitle = recipe.name
            destinationVC.user = user
        }
    }

}

