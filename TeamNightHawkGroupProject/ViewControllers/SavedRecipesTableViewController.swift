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
    var recipesList: [Recipe] = {
            var recipes: [Recipe] = []
            guard let recipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return []}
            RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs, completion: { (fetchedRecipes) in
                recipes = fetchedRecipes
            })
            return recipes
    }()
    
    var usersList: [User] {
        var users: [User] = []
        for recipe in recipesList {
            let userRef = recipe.userReference
            UserController.shared.fetchUser(withUserRef: userRef) { (user) in
                users.append(user)
            }
        }
        
        return users
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.reloadData()
        tabBarController?.delegate = self
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell
        cell?.recipe = recipesList[indexPath.row]
        cell?.user = usersList[indexPath.row]
        return cell ?? UITableViewCell()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSavedToRecipeDVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? RecipeDetailTableViewController else {return}
            let recipe = recipesList[indexPath.row]
            destinationVC.recipe = recipe
        }
    }

}

extension SavedRecipesTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        tableView.reloadData()
    }
}
