//
//  SavedRecipeTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/21/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol SavedRecipeTableViewCellDelegate {
    func performSegue(forUser user: User)
}


class SavedRecipeTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    var user: User?
    var delegate: SavedRecipeTableViewCellDelegate?
    
    //MARK: - IBOutlets
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var userDisplayName: UIButton!
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameTextLabel: UILabel!
    @IBOutlet weak var recipeServingsTextLabel: UILabel!
    @IBOutlet weak var recipePrepTimeTextLabel: UILabel!
    @IBOutlet weak var recipeSaveCountTextLabel: UILabel!
    
    
    @IBAction func moreOptionsButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func displayNameButtonTapped(_ sender: Any) {
        guard let user = user else { print("🍒 This cell has no user, come check. Printing from \(#function) \n In \(String(describing: SavedRecipeTableViewCell.self)) 🍒") ; return }
        delegate?.performSegue(forUser: user)
    }
    
    
    //update the view
    func updateViews() {
        guard let user = user,
            let recipeImage = recipe?.image else {return}
    
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.height/2
        if let userImage = user.profileImage{userProfileImageView.image = UIImage(data: userImage)}
        else {userProfileImageView.image = UIImage(named: "ProfileDefault")}
        
        userDisplayName.setTitle(user.displayName, for: .normal)
        userDisplayName.setTitleColor(softBlue, for: .normal)
        userDisplayName.titleLabel?.font = UIFont(name: fontName, size: userNameFontSize)
        recipeImageView.image = UIImage(data: recipeImage)
        recipeNameTextLabel.text = recipe?.name
        recipeNameTextLabel.font = UIFont.boldSystemFont(ofSize: titleFontSize)
        recipeServingsTextLabel.text = recipe?.servings
        recipeServingsTextLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        recipePrepTimeTextLabel.text = recipe?.prepTime
        recipePrepTimeTextLabel.font = UIFont.boldSystemFont(ofSize: fontSize)
        recipeSaveCountTextLabel.text = "♕ \(recipe?.saveCount ?? 0)"
        recipeSaveCountTextLabel.font = UIFont.boldSystemFont(ofSize: fontSize)

    }

}
