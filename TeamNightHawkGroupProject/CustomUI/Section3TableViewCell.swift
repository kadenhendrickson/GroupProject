//
//  Section3TableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit
protocol tagCellDelegate {
    func addTag(tag: String)
    func increaseTagRows(rowCount: Int)
    func refreshTagData()
}

class Section3TableViewCell: UITableViewCell {
    
    var tagDelegate: tagCellDelegate?
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "addRecipeCell3")
        addAllSubViews()
        setUpStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addAllSubViews(){
        self.addSubview(tags)
        self.addSubview(addSection)
        self.addSubview(stackView)
        
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(tags)
        stackView.addArrangedSubview(addSection)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 8, paddingTrailing: 0, height: (fontSize + 8))
        addSection.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)

        
    }
    
    let tags: UITextField = {
        let text = UITextField()
        text.font = UIFont(name: fontName, size: fontSize)
        text.placeholder = "tags"
        
        return text
    }()
    
    @objc func addButtonTapped(){
        tagDelegate?.increaseTagRows(rowCount: 1)
        tagDelegate?.refreshTagData()
        AddRecipeTableViewController().tableView.reloadData()
        guard let tag = tags.text else {return}
        tagDelegate?.addTag(tag: tag)
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
extension Section3TableViewCell: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        
    }
}
