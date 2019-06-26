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
    var recipesList: [Recipe] {
        guard let currentUser = UserController.shared.currentUser else {return []}
        var internalRecipes: [Recipe] = []
        UserController.shared.db.collection("Users").document(currentUser.userID).getDocument { (snapshot, error) in
            if let error = error {
                print("there is an error fetching users: \(error.localizedDescription)")
            }
            guard let data = snapshot?.data(),
                    let friendsArray = data["followingRefs"] as? [String] else {return}
            
            for friend in friendsArray {
                RecipeController.shared.fetchSpecificRecipesWith(userReference: friend, completion: { (recipes) in
                    internalRecipes.append(contentsOf: recipes)
                })
            }
        }
        return internalRecipes
    }
    
    private var handle: AuthStateDidChangeListenerHandle?
    var usersList: [User] {
        var users: [User] = []
        guard let currentUserFollowingRefs = UserController.shared.currentUser?.followingRefs else {return []}
        for userRef in currentUserFollowingRefs {
            UserController.shared.fetchUser(withUserRef: userRef) { (user) in
                users.append(user)
            }
        }
        return users
    }
    
    var selectedUser: User?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        handle = Auth.auth().addStateDidChangeListener({ (auth, user) in
            if user == nil {
                let storybord = UIStoryboard(name: "Login", bundle: nil)
                let loginVC = storybord.instantiateViewController(withIdentifier: "SignIn")
                self.present(loginVC, animated: true, completion: nil)
            } 
        })
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipesList.count
    }
    
    //dont forget to change reuseIdentifier
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userFeedRecipeCell", for: indexPath) as? UserFeedTableViewCell
        cell?.delegate = self
        cell?.recipe = recipesList[indexPath.row]
        cell?.user = usersList[indexPath.row]
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
