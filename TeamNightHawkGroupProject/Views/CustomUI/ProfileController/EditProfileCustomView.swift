//
//  EditProfileCustomView.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 7/1/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class editTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
        self.layer.borderWidth = ProfileHeaderConstants.borderWidth
        self.layer.borderColor = ProfileHeaderConstants.greyBorderColor
        self.layer.cornerRadius = textFieldRounding
    }
}

class displayNameTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
        self.layer.borderWidth = ProfileHeaderConstants.borderWidth
        self.layer.borderColor = ProfileHeaderConstants.greyBorderColor
        self.layer.cornerRadius = textFieldRounding
    }
}

class deleteProfileButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(white, for: .normal)
        self.backgroundColor = UIColor.red
        self.heightAnchor.constraint(equalToConstant: saveButtonSize)
        self.layer.cornerRadius = ProfileHeaderConstants.buttonBorderRadius
    }
}


