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
    var user: User? {
        didSet {
            tableView.reloadData()
        }
    }
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
        guard let user = user,
        let imageData = user.profileImage else {return}
        viewedUserBiography.text = user.biography
        viewedUserDisplayName.text = user.displayName
        viewedUserFollowersCount.text = "\(user.followedByRefs.count)"
        viewedUserFollowingCount.text = "\(user.followingRefs.count)"
        viewedUserProfileImage.image = UIImage(data: imageData)
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let user = user else {return 0}
        return user.recipesRef.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as? ViewedUserRecipeTableViewCell
        let recipe = userRecipes[indexPath.row]
        cell?.user = user
        cell?.recipe = recipe
        return cell ?? UITableViewCell()
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
