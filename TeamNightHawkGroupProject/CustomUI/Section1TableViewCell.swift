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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addAllSubViews()
        setUpStackView()
    }
    
    func addAllSubViews(){
        self.addSubview(measuremenType)
        self.addSubview(measurementQuantity)
        self.addSubview(ingredient)
        self.addSubview(addSection)
        self.addSubview(stackView)
    }
    
    
    
    func setUpStackView(){
        stackView.addArrangedSubview(measurementQuantity)
        stackView.addArrangedSubview(measuremenType)
        stackView.addArrangedSubview(ingredient)
        stackView.addArrangedSubview(addSection)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, height: (fontSize + 8))
    }

    
    
    let measurementQuantity: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        
        return text
    }()
    
    let measuremenType: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        
        return text
    }()
    
    let ingredient: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)

        
        return text
    }()
    
    
    let addSection: UIButton = {
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
