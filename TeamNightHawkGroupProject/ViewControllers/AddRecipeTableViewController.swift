//
//  AddRecipeTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
import NotificationCenter

class AddRecipeTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var imageSelector: UIButton!
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    var imagePicker = ImagePickerHelper()
    
    var ingredients: [Ingredient] = []
    var steps: [String] = []
    var tags: [String] = []
    var ingredientRows: Int = 1
    var stepRows: Int = 1
    var tagRows: Int = 1
    var segmentIndex: Int = 1
    
    
    //MARK: - Methods
    func alertUser(withMessage message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        nameTextField.delegate = self
        servingTextField.delegate = self
        servingTextField.delegate = self
        prepTimeTextField.delegate = self
        
        tableView.register(Section1TableViewCell.self, forCellReuseIdentifier: "addRecipeCell")
        tableView.register(Section2TableViewCell.self, forCellReuseIdentifier: "addRecipeCell2")
        tableView.register(Section3TableViewCell.self, forCellReuseIdentifier: "addRecipeCell3")
        imageSelector.setTitle("Click to add image", for: .normal)
        saveButton.backgroundColor = buttonBackground
        
    }
    
    @IBAction func clearButtonTapped(_ sender: Any) {
    
        ingredients = []
        steps = []
        tags = []
        ingredientRows = 1
        stepRows = 1
        tagRows = 1
        nameTextField.text = ""
        servingTextField.text = ""
        prepTimeTextField.text = ""
        imageSelector.setTitle("Click to add image", for: .normal)
        recipeImage.image = nil
        
        tableView.reloadData()
        
        
    }
    
    
    @IBAction func imageSelectorTapped(_ sender: Any) {
        imagePicker.presentImagePicker(for: self)
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
        guard let image = recipeImage.image else {
                alertUser(withMessage: "Please select an image for your recipe.");
                return
        }

        guard let name = nameTextField.text,
            name != ""
            else { alertUser(withMessage: "Please put in recipe name."); return}
        
        let servingSize = servingTextField.text ?? "--"
        let prepTime = prepTimeTextField.text ?? "--"
        
        RecipeController.shared.createRecipe(name: name, image: image, ingredients: ingredients, steps: steps, tags: tags, servingSize: servingSize, prepTime: prepTime)
        performSegue(withIdentifier: "toTabBar", sender: nil)
        
    }
    
    @IBAction func userTappedView(_ sender: Any) {
        nameTextField.resignFirstResponder()
        servingTextField.resignFirstResponder()
        servingTextField.resignFirstResponder()
        prepTimeTextField.resignFirstResponder()
    }
    //MARK: - Table view data source
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if segmentIndex == 1 {
            return ingredientRows
        } else if segmentIndex == 2 {
            return stepRows
        } else {
            return tagRows
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if segmentIndex == 1 {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell", for: indexPath) as? Section1TableViewCell else {return UITableViewCell()}
            if indexPath.row != ingredients.count{
                cell.addSection.isHidden = true
            } else {
                cell.addSection.isHidden = false
            }
            cell.ingredientDelegate = self
            if tableView.numberOfRows(inSection: 0) == 1 {
                cell.clearTextFields()
            }
            
            return cell
        } else if segmentIndex == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell2", for: indexPath) as? Section2TableViewCell else {return UITableViewCell()}
            if indexPath.row != steps.count {
                cell.addSection.isHidden = true
            } else {
                cell.addSection.isHidden = false
            }
            cell.stepDelegate = self
            if tableView.numberOfRows(inSection: 0) == 1 {
                cell.clearCell()
            }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addRecipeCell3", for: indexPath) as? Section3TableViewCell else {return UITableViewCell()}
            if indexPath.row != tags.count {
                cell.addSection.isHidden = true
            } else {
                cell.addSection.isHidden = false
            }
            cell.tagDelegate = self
            if tableView.numberOfRows(inSection: 0) == 1 {
                cell.clearText()
            }
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

extension AddRecipeTableViewController: ingredientCellDelegate, stepCellDelegate, tagCellDelegate {

    func addTag(tag: String) {
        if tag == "" {
            alertUser(withMessage: "Please add a tag")
        } else {
        tagRows += 1
        tags.append(tag)
            refreshTagData()
        }
    }

    func refreshTagData() {
        tableView.reloadData()
    }
    
    func addSteps(step: String) {
        if step == "" {
            alertUser(withMessage: "Please provide a step")
        } else {
            stepRows += 1
            steps.append(step)
            refreshStepData()
        }
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
            ingredients.append(newIngredient)
            ingredientRows += 1
            refreshIngredientData()
        }
    }
    
    func refreshIngredientData() {
        tableView.reloadData()
    }
}

extension AddRecipeTableViewController: ImagePickerHelperDelegate {
    func fireActionsForSelectedImage(_ image: UIImage) {
        self.recipeImage.image = image
        imageSelector.setTitle("", for: .normal)
    }
    
}

extension AddRecipeTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
