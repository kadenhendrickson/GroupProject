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
    var refreshController = UIRefreshControl()
    
    var recipesList: [Recipe] = []
    
    // reference to recipe's user
    var usersList: [String: User] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Saved Recipes"
        tableView.separatorStyle = .none
        tableView.refreshControl = refreshController
        refreshController.addTarget(self, action: #selector(refreshControlPulled), for: .valueChanged)
        
        loadRecipes { (success) in
            guard success else { print("🍒 Failed to load. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    @objc func refreshControlPulled() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        loadRecipes { (success) in
            guard success else { print("🍒 Failed to load. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return }

            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            DispatchQueue.main.async {
                self.refreshControl?.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    

    func loadRecipes(_ completion: @escaping(Bool) -> Void) {
        // must reset fetched recipe before fetching to avoid duplicate recipes
        self.recipesList = []
        self.usersList = [:]
        
        guard let recipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return}
        
        RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs) { (recipes) in
            
            guard recipes.count > 0 else {completion(false) ;return}
            
            self.recipesList += recipes
            
            self.recipesList.sort{$1.timestamp < $0.timestamp}
            
            for recipe in self.recipesList {
                self.findUserForRecipe(with: recipe) { (fetchedUser) in
                    if let fetchedUser = fetchedUser {
                        self.usersList[recipe.recipeID] = fetchedUser
                    }
                }
            }
            
            completion(true)
            return
        }
    }
    
    func findUserForRecipe(with recipe: Recipe, completion: @escaping (User?)-> Void) {
        
        UserController.shared.fetchUser(withUserRef: recipe.userReference) { (user) in
            
            completion(user)
            return
        }
        
        completion(nil)
        return
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell
            else { print("🍒 I'm failing your cell deque because I'm a guard statement. I might deque other cells just fine but I'm failing this one. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒")
                return UITableViewCell()
        }
        
        let recipe = self.recipesList[indexPath.row]
        let user = self.usersList[recipe.recipeID]
        cell.user = user
        cell.recipe = recipe
        cell.delegate = self
        
        return cell
    }
    
    // Swipe to delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let cell = tableView.cellForRow(at: indexPath) as? SavedRecipeTableViewCell,
                 let recipe = cell.recipe
                else { print("🍒 Can't cast cell as saved recipe cell. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒") ; return }
            
//            print("Index path: \(indexPath.row)\nNo. of recipeList: \(recipesList.count).")
            
            // this remove from both fire store and source of truth
            RecipeController.shared.deleteRecipeFromUsersSavedList(WithRecipeID: recipe.recipeID)
            
            // this remove from the fetched result
            self.recipesList.remove(at: indexPath.row)

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

