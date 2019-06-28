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
