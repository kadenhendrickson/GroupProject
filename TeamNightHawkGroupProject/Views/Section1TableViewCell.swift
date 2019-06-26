//
//  Section1TableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

//Need Function to tap button
protocol ingredientCellDelegate {
    func addIngredient(ingredientName: String, measurementQuantity: String, measurementType: String)
    
    func refreshIngredientData()
}

class Section1TableViewCell: UITableViewCell {
    
    var ingredientDelegate: ingredientCellDelegate?
    var ingredient: Ingredient?
    var measurmentName: String = ""
    var measurmentQuantity: String = ""
    var ingredientName: String = ""
    
    
    
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "addRecipeCell")
        addAllSubViews()
        setUpStackView()
        
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubViews(){
        
        self.addSubview(measuremenTypeLabel)
        self.addSubview(measurementQuantityLabel)
        self.addSubview(ingredientLabel)
        self.addSubview(addSection)
        self.addSubview(stackView)
        contentView.addSubview(measuremenTypeLabel)
        measuremenTypeLabel.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: 20, height: 20)
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(measurementQuantityLabel)
        stackView.addArrangedSubview(measuremenTypeLabel)
        stackView.addArrangedSubview(ingredientLabel)
        stackView.addArrangedSubview(addSection)
        
        measurementQuantityLabel.delegate = self
        measuremenTypeLabel.delegate = self
        ingredientLabel.delegate = self
        
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 1, paddingBottom: 8, paddingLeading: 1, paddingTrailing: 8, width: 300, height: 32)
        addSection.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    func clearTextFields() {
        measurementQuantityLabel.text = ""
        measuremenTypeLabel.text = ""
        ingredientLabel.text = ""
    }
    
    
    let measurementQuantityLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "0"
        text.backgroundColor = backGround
        
        return text
    }()
    
    let measuremenTypeLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Teaspoon"
        text.backgroundColor = backGround

        
        return text
    }()
    
    let ingredientLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Ingredient"
        text.backgroundColor = backGround


        return text
    }()
    
    @objc func addButtonTapped(){
       
        guard let name = ingredientLabel.text,
            let measurmentName = measuremenTypeLabel.text,
            let measurementQuantity = measurementQuantityLabel.text
            else {return}
        
        ingredientDelegate?.refreshIngredientData()
        
        ingredientDelegate?.addIngredient(ingredientName: name, measurementQuantity: measurementQuantity, measurementType: measurmentName)
        
        print("🏚🏚🏚🏚🏚🏚🏚🏚🏚🏚")
    }
    
    
    lazy var addSection: UIButton = {
        let button = UIButton()
        button.setTitleColor(addSectionButtonColor, for: .normal)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: addSectionButtonSize)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = addSectionButtonCorner
        
        return button
    }()
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
        return stackView
    }()
//    func alertUser(withMessage message: String){
//        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
//
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//
//        alertController.addAction(cancelAction)
//
//        self.present(alertController, animated: true)
//    }
}



extension Section1TableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}


extension Section1TableViewCell: AddRecipeTableViewDelegate, EditRecipeTableViewDelegate {
    func userTappedView() {
        measurementQuantityLabel.resignFirstResponder()
        measuremenTypeLabel.resignFirstResponder()
        ingredientLabel.resignFirstResponder()
    }
}
