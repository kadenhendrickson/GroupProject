//
//  EditRecipeTableViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

protocol EditRecipeTableViewDelegate {
    func userTappedView()
    func userSwipedDown()
}

class EditRecipeTableViewController: UITableViewController {
    
    //MARK: -Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var prepTimeTextField: UITextField!
    @IBOutlet weak var servingTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var rearrangeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    
    var recipe: Recipe?
    let imagePicker: ImagePickerHelper = ImagePickerHelper()
    
    var ingredientsArray: [Ingredient] = []
    var stepsArray: [String] = []
    var tagsArray: [String] = []
    var ingredientRows: Int = 1
    var stepRows: Int = 1
    var tagRows: Int = 1
    var segmentIndex: Int = 1
    
    // current text field index for navigating nextfield via return key, this will be used for the programmatic fields' tag.
    var currentTextFieldIndex: Int = 2
    
    var delegateForKeyboardDissmiss: EditRecipeTableViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(Section1TableViewCell.self, forCellReuseIdentifier: "ingredientEditCell")
        tableView.register(Section2TableViewCell.self, forCellReuseIdentifier: "stepEditCell")
        tableView.register(Section3TableViewCell.self, forCellReuseIdentifier: "tagEditCell")
        guard let recipe = recipe,
            let imageData = recipe.image else {return}
        
        // tags for switching textFields with return key
        nameTextField.tag = 0
        servingTextField.tag = 1
        prepTimeTextField.tag = 2
        
        recipeImageView.image = UIImage(data: imageData)
        nameTextField.text = recipe.name
        servingTextField.text = recipe.servings
        prepTimeTextField.text = recipe.prepTime
        rearrangeButton.isHidden = true
        deleteButton.backgroundColor = green
        deleteButton.layer.cornerRadius = buttonRounding
        deleteButton.setTitleColor(black, for: .normal)
        
        // Delegates for dismissing keyboard
        nameTextField.delegate = self
        servingTextField.delegate = self
        prepTimeTextField.delegate = self
        panGestureRecognizer.delegate = self
        
        // Delegate for image picker
        imagePicker.delegate = self
        
    }
    
    //MARK: -Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let name = nameTextField.text,
            let recipe = recipe,
            let servingSize = servingTextField.text,
            let prepTime = prepTimeTextField.text else {return}
        guard let image = recipeImageView.image else {alertUser(withMessage: "Make sure you have an image before you save your recipe!"); return }
        recipe.ingredients.append(contentsOf: ingredientsArray)
        recipe.steps?.append(contentsOf: stepsArray)
        recipe.tags?.append(contentsOf: tagsArray)
        RecipeController.shared.updateRecipeWith(recipeID: recipe.recipeID, name: name, image: image, ingredients: recipe.ingredients, steps: recipe.steps, tags: recipe.tags, servingSize: servingSize, prepTime: prepTime)

        navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func userTappedView(_ sender: Any) {
        resignAllResponders()
    }
    
    @IBAction func rearrangeStepsButtonTapped(_ sender: Any) {
        self.isEditing = !isEditing
    }
    
    @IBAction func editImageTapped(_ sender: Any) {
        imagePicker.presentImagePicker(for: self)
    }
    
    @IBAction func deleteRecipeTapped(_ sender: Any) {
        guard let recipe = recipe else {return}
        RecipeController.shared.deleteRecipeWith(recipeID: recipe.recipeID)
        navigationController?.popViewController(animated: true)
    }
    @IBAction func segmentControllerTapped(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndex = 1
            print("⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️⬇️")
            rearrangeButton.isHidden = true
            isEditing = false
            tableView.reloadData()
        case 1:
            segmentIndex = 2
            print("🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋🌋")
            rearrangeButton.isHidden = false
            tableView.reloadData()
        case 2:
            segmentIndex = 3
            print("🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻🗻")
            rearrangeButton.isHidden = true
            isEditing = false
            tableView.reloadData()
            
        default:
            break
        }
    }
    
    // MARK: - Controller's Methods
    
    func resignAllResponders(){
        nameTextField.resignFirstResponder()
        servingTextField.resignFirstResponder()
        prepTimeTextField.resignFirstResponder()
        
        delegateForKeyboardDissmiss?.userSwipedDown()
        delegateForKeyboardDissmiss?.userTappedView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe,
            let steps = recipe.steps,
            let tags = recipe.tags else {return 0}
        if segmentIndex == 1 {
            return (recipe.ingredients.count + ingredientRows)
        } else if segmentIndex == 2 {
            return (steps.count + stepRows)
        } else {
            return (tags.count + tagRows)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let recipe = recipe,
            let steps = recipe.steps,
            let tags = recipe.tags else {return UITableViewCell()}
        tableView.separatorStyle = .none

        if segmentIndex == 1{
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientEditCell", for: indexPath) as? Section1TableViewCell else {return UITableViewCell()}
            if indexPath.row < (recipe.ingredients.count ){
                cell.measurementQuantityLabel.text = recipe.ingredients[indexPath.row].measurementQuantity
                cell.measuremenTypeLabel.text = recipe.ingredients[indexPath.row].measurementName
                cell.ingredientLabel.text = recipe.ingredients[indexPath.row].name
                cell.addSection.isHidden = true
                cell.measuremenTypeLabel.isEnabled = false
                cell.measurementQuantityLabel.isEnabled = false
                cell.ingredientLabel.isEnabled = false
                cell.ingredientDelegate = self
                self.delegateForKeyboardDissmiss = cell
                return cell
            } else {
                if indexPath.row == recipe.ingredients.count + ingredientsArray.count {
                    cell.addSection.isHidden = false
                    cell.ingredientDelegate = self
                    cell.ingredientLabel.isEnabled = true
                    self.delegateForKeyboardDissmiss = cell
                    return cell
                } else {
                    cell.addSection.isHidden = true
                    cell.ingredientDelegate = self
                    cell.measuremenTypeLabel.isEnabled = false
                    cell.measurementQuantityLabel.isEnabled = false
                    cell.ingredientLabel.isEnabled = false
                    return cell
                }
            }
        } else if segmentIndex == 2 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "stepEditCell", for: indexPath) as? Section2TableViewCell else {return UITableViewCell()}
            
            if indexPath.row < (steps.count){
                cell.directionSteps.text = steps[indexPath.row]
                cell.addSection.isHidden = true
                cell.directionSteps.isEnabled = false
                cell.stepDelegate = self
                self.delegateForKeyboardDissmiss = cell
                return cell
            } else {
                if indexPath.row == steps.count + stepsArray.count {
                    cell.addSection.isHidden = false
                    cell.stepDelegate = self
                    cell.directionSteps.isEnabled = true
                    self.delegateForKeyboardDissmiss = cell
                    return cell
                } else {
                    cell.addSection.isHidden = true
                    cell.stepDelegate = self
                    cell.directionSteps.isEnabled = false
                    return cell
                }
            }
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "tagEditCell", for: indexPath) as? Section3TableViewCell else {return UITableViewCell()}
            if indexPath.row < (tags.count){
                cell.tags.text = tags[indexPath.row]
                cell.addSection.isHidden = true
                cell.tagDelegate = self
                cell.tags.isEnabled = false
                self.delegateForKeyboardDissmiss = cell

                return cell
            } else {
                if indexPath.row == tags.count + tagsArray.count{
                    cell.addSection.isHidden = false
                    cell.tagDelegate = self
                    cell.tags.isEnabled = true
                    self.delegateForKeyboardDissmiss = cell

                    return cell
                } else {
                    cell.addSection.isHidden = true
                    cell.tagDelegate = self
                    cell.tags.isEnabled = false
                    return cell
                }
            }
        }
    }
    //MARK: -Delete cell
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let recipe = recipe,
                var steps = recipe.steps,
                var tags = recipe.tags else {print("♞♞♞♞♞♞♞♞"); return}
            if segmentIndex == 1 {
                let ingredient = recipe.ingredients[indexPath.row]
                guard let ingredientIndex = recipe.ingredients.firstIndex(of: ingredient) else {return}
                if ingredientIndex != (ingredientRows + recipe.ingredients.count){
                recipe.ingredients.remove(at: ingredientIndex )
                tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    return
                }
            } else if segmentIndex == 2 {
                if indexPath.row != (stepRows + steps.count - 1){
                let step = steps[indexPath.row]
                guard let stepIndexPath = steps.firstIndex(of: step) else {return}
                recipe.steps?.remove(at:stepIndexPath)
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                } else {
                    return
                }
            } else {
                let tag = tags[indexPath.row]
                guard let tagIndex = tags.firstIndex(of: tag) else {return}
                recipe.tags?.remove(at: tagIndex)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    //Mark: -RearrangeCells
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        guard let steps = recipe?.steps else {return false}
        if indexPath.row < (stepRows + steps.count - 1) {
            return true
        }
        return false
    }
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard let recipe = recipe,
            let steps = recipe.steps,
            let step = recipe.steps?[sourceIndexPath.row] else {return}
        recipe.steps?.remove(at: sourceIndexPath.row)
        if destinationIndexPath.row == (stepRows + steps.count - 1){
            recipe.steps?.insert(step, at: destinationIndexPath.row - 1)
        } else {
            recipe.steps?.insert(step, at: destinationIndexPath.row)
        }
    }
}
extension EditRecipeTableViewController: ingredientCellDelegate, stepCellDelegate, tagCellDelegate {
    
    func addTag(tag: String) {
        if tag == "" {
            alertUser(withMessage: "Please add a tag")
        }else {
            tagRows += 1
            tagsArray.append(tag)
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
            stepsArray.append(step)
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
            ingredientsArray.append(newIngredient)
            ingredientRows += 1
            refreshIngredientData()
        }
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

extension EditRecipeTableViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension EditRecipeTableViewController: ImagePickerHelperDelegate {
    func fireActionsForSelectedImage(_ image: UIImage) {
        recipeImageView.image = image
        self.resignAllResponders()
    }
}


extension EditRecipeTableViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        self.resignAllResponders()
        return true
    }
}


