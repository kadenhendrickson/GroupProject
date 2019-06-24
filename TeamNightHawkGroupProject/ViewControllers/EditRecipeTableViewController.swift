//
//  EditRecipeTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class EditRecipeTableViewController: UITableViewController {
    
    @IBOutlet weak var recipeImage: UIImageView!
    
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    var recipe: Recipe?
//    {
//        didSet {
//            ingredientRows = self.recipe?.ingredients.count ?? 0
//        }
//    }
    
    var ingredientsArray: [Ingredient] = []
    var stepsArray: [String] = []
    var tagsArray: [String] = []
    var ingredientRows: Int = 1
    var stepRows: Int = 1
    var tagRows: Int = 1

    var segmentIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(Section1TableViewCell.self, forCellReuseIdentifier: "ingredientEditCell")
        tableView.register(Section2TableViewCell.self, forCellReuseIdentifier: "stepEditCell")
        tableView.register(Section3TableViewCell.self, forCellReuseIdentifier: "tagEditCell")
        guard let recipe = recipe,
        let imageData = recipe.image else {return}
        recipeImage.image = UIImage(data: imageData)
        nameTextField.text = recipe.name
        servingTextField.text = recipe.servings
        prepTimeTextField.text = recipe.prepTime
    }
    
    
    @IBAction func editImageTapped(_ sender: Any) {
    }
    @IBAction func deleteRecipeTapped(_ sender: Any) {
    }
    
    //MARK: - Segment Controller
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
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe,
        let steps = recipe.steps,
        let tags = recipe.tags else {return 0}
        if segmentIndex == 1 {
            return (recipe.ingredients.count + ingredientRows)
        } else if segmentIndex == 2 {
            return (steps.count)
        } else {
            return (tags.count)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipe = recipe,
        let steps = recipe.steps,
        let tags = recipe.tags else {return UITableViewCell()}
        if segmentIndex == 1{
            
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientEditCell", for: indexPath) as? Section1TableViewCell else {return UITableViewCell()}
            if indexPath.row < (recipe.ingredients.count - 1){
                print(indexPath.row)
            cell.measurementQuantityLabel.text = recipe.ingredients[indexPath.row].measurementQuantity
            cell.measuremenTypeLabel.text = recipe.ingredients[indexPath.row].measurementName
            cell.ingredientLabel.text = recipe.ingredients[indexPath.row].name
                cell.addSection.isHidden = true
                cell.ingredientDelegate = self
                return cell
            } else {
                if indexPath.row == recipe.ingredients.count + ingredientsArray.count {
                cell.addSection.isHidden = false
                cell.ingredientDelegate = self
                    return cell
                } else {
                    cell.addSection.isHidden = true
                    cell.ingredientDelegate = self
                    return cell
                }
                
                
            }
            
        
        } else if segmentIndex == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "stepEditCell", for: indexPath) as? Section2TableViewCell else {return UITableViewCell()}
            cell.directionSteps.text = steps[indexPath.row]
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagEditCell", for: indexPath) as? Section3TableViewCell else {return UITableViewCell()}
            cell.tags.text = tags[indexPath.row]
            return cell
        }
    }
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    

    
}
extension EditRecipeTableViewController: ingredientCellDelegate, stepCellDelegate, tagCellDelegate {
    
    func addTag(tag: String) {
        tagsArray.append(tag)
    }
    func increaseTagRows(rowCount: Int) {
        tagRows += 1
    }
    func refreshTagData() {
        tableView.reloadData()
    }
    
    func addSteps(step: String) {
        stepsArray.append(step)
    }
    func increaseStepRows(rowCount: Int) {
        stepRows += rowCount
    }
    func refreshStepData() {
        tableView.reloadData()
    }
    
    func addIngredient(ingredientName: String, measurementQuantity: String, measurementType: String) {
        let newIngredient = Ingredient(name: ingredientName, measurementName: measurementType, measurementQuantity: measurementQuantity)
        if ingredientName == "" {
            alertUser(withMessage: "Please provide an Ingredient")
        }else if measurementQuantity == "" {
            alertUser(withMessage: "Please provide a quantity")
        } else if measurementType == "" {
            alertUser(withMessage: "Please provide a measurement type")
        } else {
        ingredientsArray.append(newIngredient)
        }
    }
    func increaseRows(rowCount: Int) {
        ingredientRows += rowCount
    }
    func refreshIngredientData() {
        tableView.reloadData()
    }
    
    func alertUser(withMessage message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
}


