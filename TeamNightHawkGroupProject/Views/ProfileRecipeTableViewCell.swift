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
    @IBOutlet weak var editpostButton: UIButton!
    
    
    //MARK: -Actions
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
        userProfileImageView.layer.cornerRadius = (userProfileImageView.frame.height/2)
        userDisplayName.setTitle(user.displayName, for: .normal)
        userDisplayName.titleLabel?.font = UIFont(name: fontName, size: userNameFontSize)

        userDisplayName.setTitleColor(softBlue, for: .normal)
        editpostButton.setTitleColor(softBlue, for: .normal)
        
        recipeImageView.image = UIImage(data: recipeImageData)
        
        recipeNameTextLabel.text = recipe.name
        recipeNameTextLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        recipeServingsTextLabel.text = recipe.servings
        recipeServingsTextLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        recipePrepTimeTextLabel.text = recipe.prepTime
        recipePrepTimeTextLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        recipeSaveCountTextLabel.text = "♛ \(recipe.saveCount)"
        
    }
    
}


