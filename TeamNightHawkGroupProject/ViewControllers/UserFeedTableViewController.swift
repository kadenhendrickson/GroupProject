//
//  UserFeedTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import FirebaseAuth

class UserFeedTableViewController: UITableViewController, UserFeedTableViewCellDelegate {
    //MARK: - Properties
    var recipesList: [Recipe]? {
        didSet{
            print("Recipe Count: \(self.recipesList?.count)")
            tableView.reloadData()
        }
    }
    var usersList: [User]?
    
    var selectedUser: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //helper functions
    func loadUsers() {
        usersList = []
        recipesList = []
        guard let currentUserFollowingRefs = UserController.shared.currentUser?.followingRefs else {return}
        for userRef in currentUserFollowingRefs {
            UserController.shared.fetchUser(withUserRef: userRef) { (user) in
                self.usersList?.append(user)
                RecipeController.shared.fetchSpecificRecipesWith(userReference: userRef, completion: { (recipes) in
                    self.recipesList?.append(contentsOf: recipes)
                })
            }
        }
    }
    
    func findUserForRecipe(with recipe: Recipe) -> User? {
        guard let usersList = usersList else {return nil}
        for user in usersList {
            if recipe.userReference == user.userID {
                return user
            }
        }
        return nil
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let numberOfRows = recipesList?.count else {return 0}
        print("\(numberOfRows)")
        return numberOfRows
    }
    
    //dont forget to change reuseIdentifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedRecipeCell", for: indexPath) as? UserFeedTableViewCell
        guard let recipe = recipesList?[indexPath.row] else {return UITableViewCell()}
        cell?.delegate = self
        cell?.recipe = recipe
        cell?.user = findUserForRecipe(with: recipe)
        return cell ?? UITableViewCell()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromFeedToRecipeDVC" {
            guard let destinationVC = segue.destination as? RecipeDetailTableViewController,
                let indexPath = tableView.indexPathForSelectedRow else {return}
            let recipe = recipesList?[indexPath.row]
            destinationVC.recipe = recipe
        }
        if segue.identifier == "fromFeedToOtherUserVC" {
            guard let destinationVC = segue.destination as? UserViewedTableViewController else {return}
            destinationVC.user = selectedUser
        }
    }
    
    func userRefSent(userRef: String) {
        UserController.shared.fetchUser(withUserRef: userRef) { (user) in
            self.selectedUser = user
        }
    }
    
    
}
