//
//  StepsTableViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Bobba Kadush on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class StepsTableViewCell: UITableViewCell {

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
        self.addSubview(stackView)
        
    }
    
    func setUpStackView(){
        stackView.addArrangedSubview(directionSteps)
        stackView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0, height: (fontSize + 8))
        
    }
    
    let directionSteps: UILabel = {
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
