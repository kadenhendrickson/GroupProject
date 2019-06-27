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
        guard let recipeID = recipe?.recipeID else {return}
        RecipeController.shared.addRecipeToUsersSavedList(WithRecipeID: recipeID)
    }
    
    @IBAction func moreOptionsButtonTapped(_ sender: Any) {
        print("🕍🕍🕍🕍🕍🕍🕍")
        delegate?.popAlert()
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
        guard let user = user else {return}
        
    }
    
}


