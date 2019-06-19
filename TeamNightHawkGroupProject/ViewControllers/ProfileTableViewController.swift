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
    @IBOutlet weak var profileImageLabel: UIImageView!
    @IBOutlet weak var displayNameLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingsCountLabel: UILabel!
    @IBOutlet weak var bioTextLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @IBAction func editProfileButtonTapped(sender: Any){
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipeList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        // Configure the cell...
        
        return cell
    }
    
    

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

