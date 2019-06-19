//
//  Section2TableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class Section2TableViewCell: UITableViewCell {

    
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpStackView()
        addAllSubViews()

        
    }
    func addAllSubViews(){
        self.addSubview(directionSteps)
        self.addSubview(addSection)
        self.addSubview(stackView)
        
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(directionSteps)
        stackView.addArrangedSubview(addSection)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, height: (fontSize + 8))
        
    }
    
    let directionSteps: UITextField = {
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
