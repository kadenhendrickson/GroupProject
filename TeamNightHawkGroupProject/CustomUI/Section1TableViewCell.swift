//
//  Section1TableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

//Need Function to tap button

class Section1TableViewCell: UITableViewCell {

   
    
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
        self.addSubview(measuremenType)
        
        self.addSubview(measurementQuantity)
        self.addSubview(ingredient)
        self.addSubview(addSection)
        self.addSubview(stackView)
        contentView.addSubview(measuremenType)
        measuremenType.frame = CGRect(x: self.contentView.frame.origin.x, y: self.contentView.frame.origin.y, width: 20, height: 20)
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(measurementQuantity)
        stackView.addArrangedSubview(measuremenType)
        stackView.addArrangedSubview(ingredient)
        stackView.addArrangedSubview(addSection)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 1, paddingBottom: 8, paddingLeading: 1, paddingTrailing: 8, width: 300, height: 32)
        addSection.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
    }

    
    
    let measurementQuantity: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "0"
        
        return text
    }()
    
    let measuremenType: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Teaspoon"
        
        return text
    }()
    
    let ingredient: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "Ingredient"

        return text
    }()
    
    @objc func addButtonTapped(){
        AddRecipeTableViewController.ingredientRows += 1
        AddRecipeTableViewController().tableView.reloadData()
        print("🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️🅱️")
        

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
}

extension Section1TableViewCell{
    func cellOneSetup(){
        
    }
}
