//
//  AddRecipeTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class AddRecipeTableViewController: UITableViewController {
    

     static var ingredientRows: Int = 1
     static var stepRows: Int = 3
     static var tagRows: Int = 2
    var tableViewCell: Int?
    var rows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func segmentControllerTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            tableViewCell = 1
            print("⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️")
        case 1:
            tableViewCell = 2
            print("🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋")
        case 2:
            tableViewCell = 3
            print("🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻")
        default:
            break
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
     //MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return AddRecipeTableViewController.ingredientRows
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableViewCell == 1 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? Section1TableViewCell else {return UITableViewCell()}
            
            return cell
        } else if tableViewCell == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? Section2TableViewCell else {return UITableViewCell()}
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? Section3TableViewCell else {return UITableViewCell()}
            
            return cell
        }

    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
