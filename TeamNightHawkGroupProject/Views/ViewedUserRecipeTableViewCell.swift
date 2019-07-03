//
//  ViewedUserRecipeTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/20/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol VieweduserRecipeCellDeleget: class {
    func userRefSent(userRef: String)
    func popAlert()
}


class ViewedUserRecipeTableViewCell: UITableViewCell {
    
    //MARK: - properties
    var user: User?
    var recipe: Recipe?{
        didSet {
            updateViews()
        }
    }
    weak var delegate: VieweduserRecipeCellDeleget?

    
    //MARK: - IBOutlets
    @IBOutlet weak var viewedUserProfileImage: UIImageView!
    @IBOutlet weak var viewedUserDisplayName: UIButton!
    @IBOutlet weak var viewedUserRecipeImage: UIImageView!
    @IBOutlet weak var viewedUserRecipeNameLabel: UILabel!
    @IBOutlet weak var viewedUserServingsLabel: UILabel!
    @IBOutlet weak var viewedUserPrepTimeLabel: UILabel!
    @IBOutlet weak var viewedUserSaveCountLabel: UILabel!
    @IBOutlet weak var viewedUserSaveButton: UIButton!
    
    
    func updateViews() {
        guard let user = user,
            let recipe = recipe,
            let userImageData = user.profileImage,
            let recipeImageData = recipe.image else {return}
        
        viewedUserProfileImage.image = UIImage(data: userImageData)
        viewedUserProfileImage.layer.cornerRadius = viewedUserProfileImage.frame.height/2
        viewedUserDisplayName.setTitle(user.displayName, for: .normal)
        viewedUserDisplayName.titleLabel?.font = UIFont(name: fontName, size: userNameFontSize)
        viewedUserDisplayName.setTitleColor(softBlue, for: .normal)
        viewedUserRecipeImage.image = UIImage(data: recipeImageData)
        viewedUserRecipeNameLabel.text = recipe.name
        viewedUserRecipeNameLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        viewedUserServingsLabel.text = recipe.servings
        viewedUserServingsLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        viewedUserPrepTimeLabel.text = recipe.prepTime
        viewedUserPrepTimeLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        viewedUserSaveCountLabel.text = "♕ \(recipe.saveCount)"
        viewedUserSaveCountLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        setSavedButton()
    }
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let recipeID = recipe?.recipeID,
            let currentUser = UserController.shared.currentUser else {return}
        saveAndRemoveRecipe(recipeRef: recipeID, currentUser: currentUser)
        toggleSavedStatus()
        viewedUserSaveCountLabel.text = "♛ \(recipe?.saveCount ?? 0)"
    }
    
    @IBAction func moreButtonTapped(_ sender: Any) {
        print("🇿🇼🇿🇼🇿🇼🇿🇼🇿🇼🇿🇼🇿🇼🇿🇼")
        guard let userRef = user?.userID else {return}
        delegate?.userRefSent(userRef: userRef)
        delegate?.popAlert()
    }
    
    func setSavedButton(){
        viewedUserSaveButton.setTitle("", for: .normal)
        guard let currentUser = UserController.shared.currentUser,
            let recipeID = recipe?.recipeID else {return}
        if currentUser.savedRecipeRefs.contains(recipeID) {
            viewedUserSaveButton.setBackgroundImage(UIImage(named: "savedBookmark"), for: .normal)
        } else {
            viewedUserSaveButton.setBackgroundImage(UIImage(named: "unsavedBookmark"), for: .normal)
        }
    }
    
    func toggleSavedStatus() {
        guard let currentUser = UserController.shared.currentUser,
            let recipeID = recipe?.recipeID else {return}
        if currentUser.savedRecipeRefs.contains(recipeID) {
            viewedUserSaveButton.setBackgroundImage(UIImage(named: "savedBookmark"), for: .normal)
            //saveRecipeButton.setTitle("Saved", for: .normal)
            recipe?.savedByUsers.append(currentUser.userID)
        } else {
            viewedUserSaveButton.setBackgroundImage(UIImage(named: "unsavedBookmark"), for: .normal)
            //saveRecipeButton.setTitle("Save", for: .normal)
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
}
