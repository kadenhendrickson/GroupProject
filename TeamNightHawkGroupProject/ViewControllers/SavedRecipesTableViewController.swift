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
    // This will be passed through delegate
    var selectedUser: User?
    
    var recipesIDs: [String] = []
    
    // somehow fetching here makes user and recipe swaps, for now store them as dictionary to make it work
    
    // dictionaries of recipekey : recipe
    var recipesList: [String: Recipe] = [:] {
        didSet{
            print("🌎🌎🌎Recipes set!😝😝😝")
            print(self.recipesList.count)
        }
    }
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Recipes"
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadUsersAndRecipes()
        tableView.reloadData()
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
            else { print("🍒 I'm failing your cell deque because I'm a guard statement. I might deque other cells just fine but I'm failing this one. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒")
                return UITableViewCell()
        }
        
        let dicKey = self.recipesIDs[indexPath.row]
        let recipe = self.recipesList[dicKey]
        let user = self.usersList[dicKey]
        
        // User must get assign into cell before recipe. Or you will experience traumatic debugging event.
        cell.delegate = self
        cell.user = user
        cell.recipe = recipe
        
        return cell
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? SavedRecipeTableViewCell,
                 let recipe = cell.recipe
                else { print("🍒 Can't cast cell as saved recipe cell. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒") ; return }
            UserController.shared.currentUser?.savedRecipeRefs.remove(at: indexPath.row)
            RecipeController.shared.deleteRecipeFromUsersSavedList(WithRecipeID: recipe.recipeID)
            loadUsersAndRecipes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
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
        } else if segue.identifier == "fromSaveToOtherUserVC" {
            guard let destinationVC = segue.destination as? UserViewedTableViewController,
                let user = self.selectedUser
                else { print("🍒 Failed to meet all the conditions for segueing to Profile's detail view. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return }
            
            destinationVC.user = user
            destinationVC.navigationTitle = user.displayName

        }
    }

}

extension SavedRecipesTableViewController: SavedRecipeTableViewCellDelegate {
    func performSegue(forUser user: User) {
        self.selectedUser = user
        self.performSegue(withIdentifier: "fromSaveToOtherUserVC", sender: self)
    }
}

