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
    var currentUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserController.shared.currentUser
        tableView.reloadData()
        tabBarController?.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUser?.savedRecipeRefs.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let currentUser = currentUser,
            currentUser.savedRecipeRefs.count > 0
            else { print("🍒 There is no current user or user doesn't has any saved recipe. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell
        let recipeKey = currentUser.savedRecipeRefs[indexPath.row]
        cell?.recipe = RecipeController.shared.recipes[recipeKey]
        return cell ?? UITableViewCell()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let currentUser = currentUser else { print("🍒 There is no current user. Printing from \(#function) \n In \(String(describing: SavedRecipesTableViewController.self)) 🍒"); return }
        
        if segue.identifier == "fromSavedToRecipeDVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? RecipeDetailTableViewController else {return}
            let recipeKey = currentUser.savedRecipeRefs[indexPath.row]
            destinationVC.recipe = RecipeController.shared.recipes[recipeKey]
        }
    }

}

extension SavedRecipesTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        currentUser = UserController.shared.currentUser
        tableView.reloadData()
    }
}
