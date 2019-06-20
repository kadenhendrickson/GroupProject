//
//  Section3TableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class Section3TableViewCell: UITableViewCell {
    
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpStackView()
        addAllSubViews()
        
        
    }
    func addAllSubViews(){
        self.addSubview(tags)
        self.addSubview(addSection)
        self.addSubview(stackView)
        
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(tags)
        stackView.addArrangedSubview(addSection)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, height: (fontSize + 8))
        addSection.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        
    }
    
    let tags: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "tags"
        
        return text
    }()
    
    @objc func addButtonTapped(){
        AddRecipeTableViewController.tagRows += 1
        AddRecipeTableViewController.load()
    }
    
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
