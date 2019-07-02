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

class DisplayNameLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
    }
}

class BioTextLabel: UILabel {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.font = UIFont(name: fontName, size: fontSize)
        self.layer.borderColor = softBlue.cgColor
        self.layer.borderWidth = ProfileHeaderConstants.borderWidth
        self.layer.cornerRadius = ProfileHeaderConstants.buttonBorderRadius
    }
    
    enum VerticalAlignment {
        case top
        case middle
        case bottom
    }
    
    var verticalAlignment : VerticalAlignment = .top {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public func textRect(forBounds bounds: CGRect, limitedToNumberOfLines: Int) -> CGRect {
        let rect = super.textRect(forBounds: bounds, limitedToNumberOfLines: limitedToNumberOfLines)
        
        if UIView.userInterfaceLayoutDirection(for: .unspecified) == .rightToLeft {
            switch verticalAlignment {
            case .top:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: self.bounds.size.width - rect.size.width, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        } else {
            switch verticalAlignment {
            case .top:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y, width: rect.size.width, height: rect.size.height)
            case .middle:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height) / 2, width: rect.size.width, height: rect.size.height)
            case .bottom:
                return CGRect(x: bounds.origin.x, y: bounds.origin.y + (bounds.size.height - rect.size.height), width: rect.size.width, height: rect.size.height)
            }
        }
    }
}

class MainProfileHeaderButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setTitleColor(black, for: .normal)
        self.backgroundColor = ProfileHeaderConstants.buttonColor
        self.heightAnchor.constraint(equalToConstant: saveButtonSize)
        self.layer.cornerRadius = ProfileHeaderConstants.buttonBorderRadius
    }
}

class ProfilePicture: UIImageView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 50
        self.clipsToBounds = true
    }
}
