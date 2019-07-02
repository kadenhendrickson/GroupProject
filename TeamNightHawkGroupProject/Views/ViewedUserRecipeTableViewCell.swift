//
//  ViewedUserRecipeTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/20/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class ViewedUserRecipeTableViewCell: UITableViewCell {
    
    //MARK: - properties
    var user: User?
    var recipe: Recipe?{
        didSet {
            updateViews()
        }
    }
    
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
    }
    
   
}
