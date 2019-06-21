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
    var savedRecipesList: [Recipe] {
        guard let currentSavedRefs = currentUser?.savedRecipeRefs else {return []}
        var recipes: [Recipe] = []
        for (id, recipe) in RecipeController.shared.recipes {
            for ref in currentSavedRefs {
                if id == ref {
                    recipes.append(recipe)
                }
            }
        }
        return recipes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentUser = UserController.shared.currentUser
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedRecipesList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell
        let recipe = savedRecipesList[indexPath.row]
        cell?.recipe = recipe
        return cell ?? UITableViewCell()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSavedToRecipeDVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? RecipeDetailTableViewController else {return}
            let recipe = savedRecipesList[indexPath.row]
            destinationVC.recipe = recipe
        }
    }

}
