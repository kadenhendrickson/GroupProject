//
//  UserFeedTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class UserFeedTableViewCell: UITableViewCell {
    
    var recipe: Recipe? {
        didSet {
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
        guard let recipeID = recipe?.recipeID else {return}
        RecipeController.shared.addRecipeToUsersSavedList(WithRecipeID: recipeID)
    }
    @IBAction func moreOptionsButtonTapped(_ sender: Any) {
    }
    //update the view
    func updateViews() {
        guard let userRef = recipe?.userReference,
            let user = UserController.shared.users[userRef],
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
    
    

}
