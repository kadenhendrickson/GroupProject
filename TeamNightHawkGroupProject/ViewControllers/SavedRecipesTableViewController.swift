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
    var recipesList: [Recipe]? {
        didSet{
            print("😝😝😝Recipes set!😝😝😝")
            print(self.recipesList?.count)
        }
    }
        
    
    var usersList: [User]? {
        didSet {
            print("😝😝😝User was set😝😝😝")
            print(self.usersList?.count)
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsersAndRecipes()
        tabBarController?.delegate = self
    }
    
    func loadUsersAndRecipes() {
        recipesList = []
        usersList = []
        guard let recipeRefs = UserController.shared.currentUser?.savedRecipeRefs else {return}
        RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs) { (recipes) in
            self.recipesList?.append(contentsOf: recipes)
            for recipe in recipes {
                let userRef = recipe.userReference
                UserController.shared.fetchUser(withUserRef: userRef, completion: { (user) in
                    self.usersList?.append(user)
                })
            }
        }
        
        //        RecipeController.shared.fetchRecipesWith(recipeReferences: recipeRefs, completion: { (fetchedRecipes) in
//            recipes = fetchedRecipes
//            print("Fetched \(fetchedRecipes.count) recipes")
//        })
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList?.count ?? 0
        

    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? SavedRecipeTableViewCell,
            let usersList = self.usersList,
            let recipesList = self.recipesList else { return UITableViewCell() }

        cell.user = usersList[indexPath.row]
        cell.recipe = recipesList[indexPath.row]
        
        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromSavedToRecipeDVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? RecipeDetailTableViewController else {return}
            let recipe = recipesList?[indexPath.row]
            destinationVC.recipe = recipe
        }
    }

}

extension SavedRecipesTableViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        tableView.reloadData()
    }
}
