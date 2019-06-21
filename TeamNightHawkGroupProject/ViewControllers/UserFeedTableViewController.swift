//
//  UserFeedTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class UserFeedTableViewController: UITableViewController {
    //MARK: - Properties
    var recipesList: [Recipe]  {
        var recipeArray: [Recipe] = []
        for (_, recipe) in RecipeController.shared.recipes {
            recipeArray.append(recipe)
        }
        return recipeArray
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    //dont forget to change reuseIdentifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedRecipeCell", for: indexPath) as? UserFeedTableViewCell
        let recipe = recipesList[indexPath.row]
        cell?.recipe = recipe
        return cell ?? UITableViewCell()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFeedToRecipeDVC" {
            guard let destinationVC = segue.destination as? RecipeDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            let recipe = recipesList[indexPath.row]
            destinationVC.recipe = recipe
        }
//        if segue.identifier == "fromFeedToOtherUserVC" {
//            guard let destinationVC = segue.destination as? UserViewedTableViewController,
//                //aint an index path
//                let indexPath = tableView.indexPathForSelectedRow
//                else {return}
//            let recipe = recipesList[indexPath.row]
//            let user = UserController.shared.users[recipe.userReference]
//            destinationVC.user = user
//        }
    }
}
