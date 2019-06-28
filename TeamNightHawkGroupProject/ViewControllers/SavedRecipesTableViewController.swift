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
    
    // 2. Fetch users, this becomes true when the user count match recipes count
    var usersFetchCompleted = false {
        didSet {
            allFetchCompleted = usersFetchCompleted && recipesFetchCompleted
        }
    }
    
    // 1. Fetch recipes first, this becomes true after recipes fetch completion
    var recipesFetchCompleted = false {
        didSet {
            allFetchCompleted = usersFetchCompleted && recipesFetchCompleted
        }
    }
    
    // 3. When all fetch complete reload table view
    var allFetchCompleted: Bool = false {
        didSet {
            guard self.allFetchCompleted else { return }
            tableView.reloadData()
        }
    }
    
    var recipesList: [Recipe]? {
        didSet{
            print("🌎🌎🌎Recipes set!😝😝😝")
            print(self.recipesList?.count)
        }
    }
        
    
    var usersList: [User]? {
        didSet {
            print("😝😝😝Users was set😝😝😝")
            print(self.usersList?.count)
            
            // Since the user fetch occur in a for loop and back thread, it's hard to capture when the load is finished, so I'm counting them instead
            guard recipesFetchCompleted,
                self.usersList?.count == self.recipesList?.count else { return }
            usersFetchCompleted = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsersAndRecipes()
    }
    
    func loadUsersAndRecipes() {
        
        recipesList = []
        usersList = []
        
        guard let recipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return}
        RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs) { (recipes) in
            
            guard recipes.count > 0 else {return}
            
            self.recipesList?.append(contentsOf: recipes)
            self.recipesFetchCompleted = true
            
            for recipe in recipes {
                let userRef = recipe.userReference
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    self.usersList?.append(user)
                })
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard self.recipesList?.count == self.usersList?.count else {
            print("🍒 Tableview tried to deque cells before all data are loaded, it's a good thing you invested in this guard statement. I actually doubt if this statement will actually be triggered. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒")
            return UITableViewCell()
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell,
            let recipe = self.recipesList?[indexPath.row],
            let user = self.usersList?[indexPath.row]
            else { print("🍒 I'm failing your cell deque because I'm a guard statement. I might deque other cells just fine but I'm failing this one. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return UITableViewCell() }

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
            destinationVC.user = user
        }
    }

}

