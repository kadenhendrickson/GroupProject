//
//  ProfileTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class ProfileTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var recipeList: [Recipe]{
        // Fetch here and return result of fetch
        return []
    }
    
    // MARK: - IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var bioTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    func updateViews(){
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "profileRecipeCell", for: indexPath) as? ProfileRecipeTableViewCell
            else { return UITableViewCell() }
        
        let recipe = recipeList[indexPath.row]
        cell.recipe = recipe
        return cell
    }
    
    

     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // pass on recipe for both scenes
        guard let indexPath = tableView.indexPathForSelectedRow
            else { print("🍒 Can't find indexPath for the current recipe. Printing from \(#function) \n In \(String(describing: ProfileTableViewController.self)) 🍒"); return }
        
        let recipeToPass = self.recipeList[indexPath.row]

        if segue.identifier == "fromProfileToRecipeDVC"{
            
        // from recipe cell to recipe's detailVC
            guard let destinationVC = segue.destination as? RecipeDetailTableViewController else { return }
            destinationVC.recipe = recipeToPass

        } else if segue.identifier == "toEditVC" {
            
        // from recipe's edit button to recipe's EditVC scene
            guard let destinationVC = segue.destination as? EditRecipeTableViewController else { return }
            destinationVC.recipe = recipeToPass
        }
     }
}

