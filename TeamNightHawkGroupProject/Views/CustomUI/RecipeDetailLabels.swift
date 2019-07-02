//
//  RecipeDetailLabels.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 7/2/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class RecipeDetailLabels: UILabel {

    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateFonts(fontName: fontName)
        self.textColor = black

    }
    
    func updateFonts(fontName: String) {
        let size = self.font.pointSize
        self.font = UIFont(name: fontName, size: size)
    }
    
    

}
