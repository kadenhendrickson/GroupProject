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
        measuremenType.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: measurementQuantity.trailingAnchor, trailing: ingredient.leadingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 8, paddingTrailing: 8,width: 125)
        measurementQuantity.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: measuremenType.leadingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 8, paddingTrailing: 8, width: 50)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 20, paddingTrailing: 20)
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
        stackView.alignment = .leading
//        stackView.distribution = .equalSpacing
        stackView.spacing = 8
        return stackView
    }()
}
