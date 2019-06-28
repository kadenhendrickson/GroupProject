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
            fetchRecipes()
        }
    }
    
    var userRecipes: [Recipe]? {
        didSet {
            guard self.userRecipes != nil else { print("🍒 Fetched user recipes and got nil. Printing from \(#function) \n In \(String(describing: UserViewedTableViewController.self)) 🍒"); return}
            tableView.reloadData()
//            setUpViews()
        }
    }
    
//    {
//        var recipes: [Recipe] = []
//        guard let userReference = user?.userID else {return []}
//        RecipeController.shared.fetchSpecificRecipesWith(userReference: userReference) { (userRecipes) in
//            recipes = userRecipes
//        }
//        return recipes
//    }

    
    //MARK: - IBOutlets
    @IBOutlet weak var viewedUserProfileImage: UIImageView!
    @IBOutlet weak var viewedUserDisplayName: UILabel!
    @IBOutlet weak var viewedUserFollowersCount: UILabel!
    @IBOutlet weak var viewedUserFollowingCount: UILabel!
    @IBOutlet weak var viewedUserBiography: UILabel!
    @IBOutlet weak var followButon: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpViews()
    }
    
    @IBAction func followButtonTapped(_ sender: Any) {
        guard let user = user else {return}
        if UserController.shared.currentUser!.followingRefs.contains(user.userID){
            UserController.shared.unfollowUser(withID: user.userID)
            viewedUserFollowersCount.text = "\(user.followedByRefs.count)"
            followButon.setTitle("Follow", for: .normal)
        } else {
        UserController.shared.followUser(withID: user.userID)
            viewedUserFollowersCount.text = "\(user.followedByRefs.count)"
            followButon.setTitle("Unfollow", for: .normal)
        }
    }
    
    // MARK: - Methods
    
    
    func setUpViews(){
        guard let user = user,
            let imageData = user.profileImage else {print("🍒 Can't find that user or user has no profile image. Printing from \(#function) \n In \(String(describing: UserViewedTableViewController.self)) 🍒"); return}
        
        viewedUserBiography.text = user.biography
        viewedUserDisplayName.text = user.displayName
        viewedUserFollowersCount.text = "\(user.followedByRefs.count)"
        viewedUserFollowingCount.text = "\(user.followingRefs.count)"
        viewedUserProfileImage.image = UIImage(data: imageData)
        if UserController.shared.currentUser!.followingRefs.contains(user.userID){
            followButon.setTitle("Unfollow", for: .normal)
        } else {
            followButon.setTitle("Follow", for: .normal)
        }
    }
    
    func fetchRecipes(){
        guard let userID = user?.userID else { print("🍒 Tried to unwrap userID but couldn't. Printing from \(#function) \n In \(String(describing: UserViewedTableViewController.self)) 🍒"); return}
        
        print("User reference to fetch recipe is: \(userID)")
        
        RecipeController.shared.fetchSpecificRecipesWith(userReference: userID) { (recipeList) in
                self.userRecipes = recipeList
        }
    }
    

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userRecipes?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("🌟 Now in indexPath: \(indexPath.row) from total \(user?.recipesRef.count) refs and from fetched \(self.userRecipes)")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userProfileCell", for: indexPath) as? ViewedUserRecipeTableViewCell,
            let recipe = userRecipes?[indexPath.row]
            else { print("🍒 Failed to meet all the conditions for dequeing cell for index path at: \(indexPath.row). Printing from \(#function) \n In \(String(describing: UserViewedTableViewController.self)) 🍒"); return UITableViewCell()}
        
        cell.user = user
        cell.recipe = recipe
        
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
