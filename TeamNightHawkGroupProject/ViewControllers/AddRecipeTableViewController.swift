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
    var segmentIndex: Int = 1
    var rows: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Section1TableViewCell.self, forCellReuseIdentifier: "addRecipeCell")
        tableView.register(Section2TableViewCell.self, forCellReuseIdentifier: "addRecipeCell2")
        tableView.register(Section3TableViewCell.self, forCellReuseIdentifier: "addRecipeCell3")

    }
    
    @IBAction func segmentControllerTapped(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndex = 1
            print("⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️")
            tableView.reloadData()
        case 1:
            segmentIndex = 2
            print("🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋")
            tableView.reloadData()
        case 2:
            segmentIndex = 3
            print("🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻")
            tableView.reloadData()

        default:
            break
        }
    }
    
    
    @IBAction func saveButtonTapped(_ sender: Any) {
    }
    
     //MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentIndex == 1{
        return AddRecipeTableViewController.ingredientRows
        } else if segmentIndex == 2{
            return AddRecipeTableViewController.stepRows
        }else{
            return AddRecipeTableViewController.tagRows
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentIndex == 1 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? Section1TableViewCell else {return UITableViewCell()}
            
            return cell
        } else if segmentIndex == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell2", for: indexPath) as? Section2TableViewCell else {return UITableViewCell()}

            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell3", for: indexPath) as? Section3TableViewCell else {return UITableViewCell()}

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
