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
        viewedUserDisplayName.setTitle(user.displayName, for: .normal)
        viewedUserRecipeImage.image = UIImage(data: recipeImageData)
        viewedUserRecipeNameLabel.text = recipe.name
        viewedUserServingsLabel.text = recipe.servings
        viewedUserPrepTimeLabel.text = recipe.prepTime
        viewedUserSaveCountLabel.text = "\(recipe.saveCount)"
    }
    
   
}
