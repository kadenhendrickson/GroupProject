//
//  TagsTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class TagsTableViewCell: UITableViewCell {
   
    var safeArea: UILayoutGuide {
        return self.safeAreaLayoutGuide
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "tagsCell")
        addAllSubViews()
        setUpStackView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubViews(){
        self.addSubview(hashTag)
        self.addSubview(stackView)
        
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(hashTag)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 12, paddingBottom: 0, paddingLeading: 8, paddingTrailing: 0)
        
    }
    
    let hashTag: UILabel = {
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
