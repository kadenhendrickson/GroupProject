//
//  ProfileTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var currentUser: User? {
        didSet {
            updateUserRecipes()
        }
    }
    
    var recipeList: [Recipe] = []
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var bioTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViews()
        currentUser = UserController.shared.currentUser
    }
    
    
    // MARK: - Methods
    func updateUserRecipes(){
        var recipes: [Recipe] = []
        
        guard let currentUser = UserController.shared.currentUser else { print("🍒 Tried to get all recipes from current user but can't find current user. Printing from \(#function) \n In \(String(describing: ProfileTableViewController.self)) 🍒"); return}
        
        for ref in currentUser.recipesRef {
            guard let recipe = RecipeController.shared.recipes[ref] else { print("🍒 Tried to fet a recipe from source of truth with user's recipe ref but couldn't find one. Printing from \(#function) \n In \(String(describing: ProfileTableViewController.self)) 🍒") ; break}
            
            recipes.append(recipe)
        }
        
        self.recipeList = recipes
    }
    
    
    func updateViews(){
        guard let currentUser = UserController.shared.currentUser else { print("🍒 Cannot find a current user. Printing from \(#function) \n In \(String(describing: ProfileTableViewController.self)) 🍒"); return }
        
        if let profileImageData = currentUser.profileImage {
            profileImageView.image = UIImage(data: profileImageData)
        } else {
            profileImageView.image = UIImage(named: "duck")
        }
        
        let displayName = currentUser.displayName
        let followersCount = currentUser.followedByRefs.count
        let followingsCount = currentUser.followingRefs.count
        let bioText = currentUser.biography
        
        displayNameLabel.text = displayName
        bioTextLabel.text = bioText
        followersCountLabel.text = bioText
        followersCountLabel.text = "\(followersCount)"
        followingsCountLabel.text = "\(followingsCount)"
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileRecipeCell", for: indexPath) as? ProfileRecipeTableViewCell
            else { return UITableViewCell() }
        
        let recipe = recipeList[indexPath.row]
        cell.recipe = recipe
        return cell
    }
    
}

