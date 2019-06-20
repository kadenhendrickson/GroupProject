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
    var recipeSegmentIndex: Int = 1
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: "ingredentCell")
        tableView.register(StepsTableViewCell.self, forCellReuseIdentifier: "stepsCell")
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "tagsCell")
        updateDetails()
    }
   
    
    @IBAction func segmentDetailControllerTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            recipeSegmentIndex = 1
            print("⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️")
            tableView.reloadData()
        case 1:
            recipeSegmentIndex = 2
            print("🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋")
            tableView.reloadData()
        case 2:
            recipeSegmentIndex = 3
            print("🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻")
            tableView.reloadData()
            
        default:
            break
        }
    }
    //cant call navigation controller without embedding it
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        
    }
    
    func updateDetails() {
        
        guard let recipe = recipe,
                let imageData = recipe.image,
                let user = UserController.shared.users[recipe.userReference],
                let profileImage = UserController.shared.users[recipe.userReference]?.profileImage else {return}
        userImage.image = UIImage(data: profileImage)
        userNameLabel.setTitle(user.displayName, for: .normal)
        recipeImage.image = UIImage(data: imageData)
        nameLabel.text = recipe.name
        servingsLabel.text = recipe.servings
        prepTimeLabel.text = recipe.prepTime
        
    }
    

    
    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let ingredients = recipe?.ingredients,
        let steps = recipe?.steps,
        let tags = recipe?.tags else {return 0}
        
        if recipeSegmentIndex == 1 {
            return ingredients.count
        } else if recipeSegmentIndex == 2 {
            return steps.count
        } else {
            return tags.count
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        // Configure the cell...
        if recipeSegmentIndex == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredentCell", for: indexPath) as? IngredientsTableViewCell,
                let recipe = recipe else {return UITableViewCell()}
            
            cell.measurementQuantity.text = recipe.ingredients[indexPath.row].measurementQuantity
            cell.measuremenType.text = recipe.ingredients[indexPath.row].measurementName
            cell.ingredient.text = recipe.ingredients[indexPath.row].name
            
            return cell
        }else if recipeSegmentIndex == 2{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "stepsCell", for: indexPath) as? StepsTableViewCell,
                let recipe = recipe,
                let steps = recipe.steps else {return UITableViewCell()}
            
            cell.directionSteps.text = steps[indexPath.row]
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as? TagsTableViewCell,
            let hashTag = recipe?.tags
                else {return UITableViewCell()}
            
            cell.hashTag.text = hashTag[indexPath.row]
            
            return cell
        }
    }
}
