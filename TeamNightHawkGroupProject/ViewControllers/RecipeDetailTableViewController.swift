//
//  RecipeDetailTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class RecipeDetailTableViewController: UITableViewController {
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UIButton!
    
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var servingsLabel: UILabel!
    @IBOutlet weak var prepTimeLabel: UILabel!
    
    // this get set to somthing else from vc that segues to this vc
    var navigationTitle = "Recipe"
    
    var recipe: Recipe? {
        didSet {
            fetchUser()
        }
    }
    
    var user: User? {
        didSet {
            guard user != nil else { return }
            updateDetails()
        }
    }
    var recipeSegmentIndex: Int = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableHeaderView?.tintColor = softBlue
        self.navigationItem.title = navigationTitle
        
        tableView.register(IngredientsTableViewCell.self, forCellReuseIdentifier: "ingredentCell")
        tableView.register(StepsTableViewCell.self, forCellReuseIdentifier: "stepsCell")
        tableView.register(TagsTableViewCell.self, forCellReuseIdentifier: "tagsCell")
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

    
    func fetchUser(){
        guard let recipe = recipe else { print("🍒 There's no recipeto fetch. Printing from \(#function) \n In \(String(describing: RecipeDetailTableViewController.self)) 🍒"); return}
        
        
        UserController.shared.fetchUser(withUserRef: recipe.userReference) { (user) in
            self.user = user
            if self.user == nil {
                print("🍒 Failed to assign fetched user to self.user. Printing from \(#function) \n In \(String(describing: RecipeDetailTableViewController.self)) 🍒")
            }
        }
    }
    
    func updateDetails() {
        loadViewIfNeeded()
        guard let recipe = recipe,
            let recipeImageData = recipe.image,
            let recipeImage = UIImage(data: recipeImageData),
            let user = user else { print("🍒 Something is wrong with this recipe, come here and check. Printing from \(#function) \n In \(String(describing: RecipeDetailTableViewController.self)) 🍒"); return }
        
        self.recipeImageView.image = recipeImage

        let displayName = user.displayName
        let imageData = user.profileImage
        
        if let imageData = imageData,
            let userImageData = UIImage(data: imageData) {
            userImageView.image = userImageData
        } else {
            userImageView.image = UIImage(named: "duck")

        }
        
        self.userNameLabel.setTitle(displayName, for: .normal)
        self.nameLabel.text = recipe.name
        self.servingsLabel.text = recipe.servings
        self.prepTimeLabel.text = recipe.prepTime
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
        
        tableView.separatorStyle = .none

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
            
            cell.directionSteps.text = "Step \(indexPath.row + 1): \(steps[indexPath.row])"
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as? TagsTableViewCell,
            let hashTag = recipe?.tags
                else {return UITableViewCell()}
            
            cell.hashTag.text = hashTag[indexPath.row]
            
            return cell
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toProfileTableViewController" {
            guard let destinationVC = segue.destination as? UserViewedTableViewController,
                let user = self.user
            else { print("🍒 Failed to meet all the conditions for segueing. Printing from \(#function) \n In \(String(describing: RecipeDetailTableViewController.self)) 🍒"); return }
            
            destinationVC.user = user
            destinationVC.title = user.displayName
        }
    }
    
}
