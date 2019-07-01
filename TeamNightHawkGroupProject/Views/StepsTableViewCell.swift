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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: "stepsCell")
        addAllSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addAllSubViews(){
        self.addSubview(directionSteps)
        directionSteps.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: safeArea.leadingAnchor, trailing: safeArea.trailingAnchor, paddingTop: 0, paddingBottom: 0, paddingLeading: 0, paddingTrailing: 0)
        
    }
    
    let directionSteps: UILabel = {
        let text = UILabel()
        text.font = UIFont(name: fontName, size: fontSize)
        text.numberOfLines = 0
        return text
    }()


}
