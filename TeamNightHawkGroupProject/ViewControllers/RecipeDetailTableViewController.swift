//
//  RecipeDetailTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UIButton!
    
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    
    var recipe: Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = recipe,
        let imageData = recipe.image,
        let user = UserController.shared.users[recipe.userReference],
        let profileImage = UserController.shared.users[recipe.userReference]?.profileImage  else {return}
        userImage.image = UIImage(data: profileImage)
        userNameLabel.setTitle(user.displayName, for: .normal)
        recipeImage.image = UIImage(data: imageData)
        nameLabel.text = recipe.name
        servingsLabel.text = recipe.servings
        prepTimeLabel.text = recipe.prepTime
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients"
        }else if section == 1 {
        return "Directions"
        } else {
        return "Tags"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let recipe = recipe else {return 0}
        if section == 0{
            return recipe.ingredients.count
        }else if section == 1 {
        guard let steps = recipe.steps else {return 0}
        return steps.count
        } else {
            guard let tags = recipe.tags else {return 0}
            return tags.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Configure the cell...
        if indexPath.section == 0{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? IngredientsTableViewCell,
                let recipe = recipe else {return UITableViewCell()}
            
            cell.measurementQuantity.text = recipe.ingredients[indexPath.row].measurementQuantity
            cell.measuremenType.text = recipe.ingredients[indexPath.row].measurementName
            cell.ingredient.text = recipe.ingredients[indexPath.row].name
            
            return cell
        }else if indexPath.section == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? StepsTableViewCell,
                let recipe = recipe,
                let steps = recipe.steps else {return UITableViewCell()}
            
            cell.directionSteps.text = steps[indexPath.row]
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? TagsTableViewCell,
            let hashTag = recipe?.tags
                else {return UITableViewCell()}
            
            cell.hashTag.text = hashTag[indexPath.row]
            
            return cell
        }
    }
}
