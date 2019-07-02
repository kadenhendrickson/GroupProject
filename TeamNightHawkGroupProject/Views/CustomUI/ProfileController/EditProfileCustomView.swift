//
//  EditProfileCustomView.swift
//  TeamNightHawkGroupProject
//
//  Created by Annicha Hanwilai on 7/1/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

struct EditProfileConstants {
    // Buttons
    static let buttonBorderRadius = textFieldRounding
    static let borderWidth = CGFloat(0.8)
    
    // TextFields
    static let greyBorderColor = grey.cgColor
    static let buttonColor = green
}

class editTextView: UITextView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
        self.layer.borderWidth = EditProfileConstants.borderWidth
        self.layer.borderColor = EditProfileConstants.greyBorderColor
        self.layer.cornerRadius = textFieldRounding
    }
}

class displayNameTextField: UITextField {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
        self.layer.borderWidth = EditProfileConstants.borderWidth
        self.layer.borderColor = EditProfileConstants.greyBorderColor
        self.layer.cornerRadius = textFieldRounding
    }
}

class editProfileButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(white, for: .normal)
        self.backgroundColor = EditProfileConstants.buttonColor
        self.heightAnchor.constraint(equalToConstant: saveButtonSize)
        self.layer.cornerRadius = EditProfileConstants.buttonBorderRadius
    }
}

class deleteProfileButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(white, for: .normal)
        self.backgroundColor = UIColor.red
        self.heightAnchor.constraint(equalToConstant: saveButtonSize)
        self.layer.cornerRadius = EditProfileConstants.buttonBorderRadius
    }
}

class ProfilePicture: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 50
        self.clipsToBounds = true
    }
}
