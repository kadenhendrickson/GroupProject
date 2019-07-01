//
//  UserFeedTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol UserFeedTableViewCellDelegate: class {
    func userRefSent(userRef: String)
    func popAlert()
}


class UserFeedTableViewCell: UITableViewCell {
    
    weak var delegate: UserFeedTableViewCellDelegate?
    
    var recipe: Recipe?
    
    
    var user: User?{
        didSet{
            updateViews()
        }
    }

    //MARK: - IBOutlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userDisplayName: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameTextLabel: UILabel!
    @IBOutlet weak var recipeServingsTextLabel: UILabel!
    @IBOutlet weak var recipePrepTimeTextLabel: UILabel!
    @IBOutlet weak var recipeSaveCountTextLabel: UILabel!
    @IBOutlet weak var saveRecipeButton: UIButton!
    
    
    //MARK: - IBActions
    @IBAction func saveRecipeButtonTapped(_ sender: UIButton) {
        guard let recipeID = recipe?.recipeID,
                let currentUser = UserController.shared.currentUser else {return}
        saveAndRemoveRecipe(recipeRef: recipeID, currentUser: currentUser)
       toggleSavedStatus()
        recipeSaveCountTextLabel.text = "\(recipe?.saveCount ?? 0)"
    }
    
    @IBAction func moreOptionsButtonTapped(_ sender: Any) {

        print("🕍🕍🕍🕍🕍🕍🕍")

        guard let userRef = user?.userID else {return}
        delegate?.userRefSent(userRef: userRef)
        delegate?.popAlert()
    }
    
    func toggleSavedStatus() {
        guard let currentUser = UserController.shared.currentUser,
                let recipeID = recipe?.recipeID else {return}
        if currentUser.savedRecipeRefs.contains(recipeID) {
            saveRecipeButton.setTitle("Saved", for: .normal)
            recipe?.savedByUsers.append(currentUser.userID)
        } else {
            saveRecipeButton.setTitle("Save", for: .normal)
            let indexPath = recipe?.savedByUsers.firstIndex(where: {$0 == currentUser.userID})
            recipe?.savedByUsers.remove(at: indexPath!)
        }
    }
    
    func saveAndRemoveRecipe(recipeRef: String, currentUser: User) {
        if currentUser.savedRecipeRefs.contains(recipeRef) {
            RecipeController.shared.deleteRecipeFromUsersSavedList(WithRecipeID: recipeRef)
        } else {
            RecipeController.shared.addRecipeToUsersSavedList(WithRecipeID: recipeRef)
        }
    }
    
    //update the view
    func updateViews() {
        guard let user = user,
            let recipeImage = recipe?.image else {return}
        
        if let userImage = user.profileImage{userProfileImageView.image = UIImage(data: userImage)}
        else {userProfileImageView.image = UIImage(named: "ProfileDefault")}
        
        userDisplayName.setTitle(user.displayName, for: .normal)
        recipeImageView.image = UIImage(data: recipeImage)
        recipeNameTextLabel.text = recipe?.name
        recipeServingsTextLabel.text = recipe?.servings
        recipePrepTimeTextLabel.text = recipe?.prepTime
        recipeSaveCountTextLabel.text = "\(recipe?.saveCount ?? 0)"
    }
    
    @IBAction func otherUserProfileButtonTapped(_ sender: UIButton) {
        guard let userRef = user?.userID else {return}
        delegate?.userRefSent(userRef: userRef)
    }
    
}


