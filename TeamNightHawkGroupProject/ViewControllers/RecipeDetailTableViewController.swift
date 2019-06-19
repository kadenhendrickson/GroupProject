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
    @IBOutlet weak var recipeImage: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    
    var recipe: Recipe?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let recipe = recipe,
        let imageData = recipe.image,
        let user = UserController.shared.users[recipe.userReference] else {return}
        userImage.image = UIImage(data: imageData)
        userNameLabel.setTitle(user.displayName, for: .normal)
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    

    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Ingredients"
        }
        return "Directions"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let recipe = recipe else {return 0}
        if section == 0{
            return recipe.ingredients.count
        }
        guard let steps = recipe.steps else {return 0}
        return steps.count
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
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as? StepsTableViewCell,
                let recipe = recipe,
                let steps = recipe.steps else {return UITableViewCell()}
            
            cell.directionSteps.text = steps[indexPath.row]
            
            return cell
        }
    }
}
