//
//  IngredientsTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class IngredientsTableViewCell: UITableViewCell {

    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "ingredentCell")
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
        self.addSubview(stackView)
    }
    
    
    
    func setUpStackView(){
        stackView.addArrangedSubview(measurementQuantity)
        stackView.addArrangedSubview(measuremenType)
        stackView.addArrangedSubview(ingredient)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, height: (fontSize + 8))
    }
    
    
    
    let measurementQuantity: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: fontName, size: fontSize)
        
        return text
    }()
    
    let measuremenType: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: fontName, size: fontSize)
        
        return text
    }()
    
    let ingredient: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: fontName, size: fontSize)
        
        
        return text
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
