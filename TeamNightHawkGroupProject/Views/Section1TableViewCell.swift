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
//        measuremenTypeLabel.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: 20, height: 20)
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(measurementQuantityLabel)
        stackView.addArrangedSubview(measuremenTypeLabel)
        stackView.addArrangedSubview(ingredientLabel)
        stackView.addArrangedSubview(addSection)
        
        measurementQuantityLabel.delegate = self
        measuremenTypeLabel.delegate = self
        ingredientLabel.delegate = self
        
        measurementQuantityLabel.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: measuremenTypeLabel.leadingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 8, paddingTrailing: 0, width: 60)
        measuremenTypeLabel.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: measurementQuantityLabel.trailingAnchor, trailing: ingredientLabel.leadingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 8,width: 125)
        ingredientLabel.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: measuremenTypeLabel.trailingAnchor, trailing: addSection.leadingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 8)
        addSection.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 20, paddingTrailing: -4)
        addSection.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    func clearTextFields() {
        measurementQuantityLabel.text = ""
        measuremenTypeLabel.text = ""
        ingredientLabel.text = ""
    }
    
    
    func resignAllResponders(){
        measurementQuantityLabel.resignFirstResponder()
        measuremenTypeLabel.resignFirstResponder()
        ingredientLabel.resignFirstResponder()
    }
    
    
    let measurementQuantityLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.backgroundColor = .white
        
        text.placeholder = "0"
        
        text.layer.cornerRadius = textFieldRounding
        text.layer.borderWidth = 0.5
        text.layer.borderColor = grey.cgColor
        
        return text
    }()
    
    let measuremenTypeLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Teaspoon"
        text.backgroundColor = .white
        text.layer.cornerRadius = textFieldRounding
        text.layer.borderWidth = 0.5
        text.layer.borderColor = grey.cgColor

        return text
    }()
    
    let ingredientLabel: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Ingredient"
        text.backgroundColor = .white
        text.layer.cornerRadius = textFieldRounding
        text.layer.borderWidth = 0.5
        text.layer.borderColor = grey.cgColor


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
        button.setTitleColor(softBlue, for: .normal)
        
        return button
    }()
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
//        stackView.spacing = 8
        return stackView
    }()

}



extension Section1TableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let nextField = self.superview?.viewWithTag(textField.tag + 1) as? UITextField {
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


extension Section1TableViewCell: AddRecipeTableViewDelegate, EditRecipeTableViewDelegate {
    func userTappedView() {
        self.resignAllResponders()
    }
    
    func userSwipedDown() {
        self.resignAllResponders()
    }
}
