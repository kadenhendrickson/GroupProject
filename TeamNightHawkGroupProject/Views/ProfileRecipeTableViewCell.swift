//
//  ProfileRecipeTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol ProfileRecipeCellEditButtonDelegate {
    func editButtonTapped(_ cell: ProfileRecipeTableViewCell)
}

class ProfileRecipeTableViewCell: UITableViewCell {
    
    // MARK: - Properties
    
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    var delegate: ProfileRecipeCellEditButtonDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userDisplayName: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameTextLabel: UILabel!
    @IBOutlet weak var recipeServingsTextLabel: UILabel!
    @IBOutlet weak var recipePrepTimeTextLabel: UILabel!
    @IBOutlet weak var recipeSaveCountTextLabel: UILabel!
    
    @IBAction func editButtonTapped(_ sender: Any) {
        delegate?.editButtonTapped(self)
    }
    
    // MARK: - Methods
    func updateViews(){
        
        guard let user = UserController.shared.currentUser,
            let recipe = self.recipe,
            let recipeImageData = recipe.image,
            let userImageData = user.profileImage else { return }
        
        userProfileImageView.image = UIImage(data: userImageData)
        userDisplayName.setTitle(user.displayName, for: .normal)
        
        recipeImageView.image = UIImage(data: recipeImageData)
        recipeNameTextLabel.text = recipe.name
        recipeServingsTextLabel.text = recipe.servings
        recipePrepTimeTextLabel.text = recipe.prepTime
        recipeSaveCountTextLabel.text = "\(recipe.saveCount)"
        
    }
    
}


