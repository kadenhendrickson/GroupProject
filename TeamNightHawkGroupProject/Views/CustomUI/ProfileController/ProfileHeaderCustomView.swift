//
//  ProfileHeaderCustomView.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 7/1/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

import UIKit

struct ProfileHeaderConstants {
    // Buttons
    static let buttonBorderRadius = textFieldRounding
    static let borderWidth = CGFloat(0.8)
    
    // TextFields
    static let greyBorderColor = grey.cgColor
    static let buttonColor = green
}


class ProfileButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(white, for: .normal)
        self.backgroundColor = ProfileHeaderConstants.buttonColor
        self.heightAnchor.constraint(equalToConstant: saveButtonSize)
        self.layer.cornerRadius = EditProfileConstants.buttonBorderRadius
    }
}

class ProfilePictureInDetailView: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = (self.frame.height/2)
        self.clipsToBounds = true
    }
}

