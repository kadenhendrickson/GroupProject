//
//  UserViewedTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class UserViewedTableViewController: UITableViewController {

    //MARK: - Properties
    var user: User?
    var userRecipes: [Recipe] {
        var recipes: [Recipe] = []
        for (_, recipe) in RecipeController.shared.recipes {
            if recipe.userReference == user?.userID {
                recipes.append(recipe)
            }
        }
        return recipes
    }
    
    //MARK: - IBOutlets
    @IBOutlet weak var viewedUserProfileImage: UIImageView!
    @IBOutlet weak var viewedUserDisplayName: UILabel!
    @IBOutlet weak var viewedUserFollowersCount: UILabel!
    @IBOutlet weak var viewedUserFollowingCount: UILabel!
    @IBOutlet weak var viewedUserBiography: UILabel!
    @IBOutlet weak var followButon: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userRecipes.count 
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let recipe = userRecipes[indexPath.row]
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
