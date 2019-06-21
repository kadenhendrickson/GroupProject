//
//  ExploreCollectionViewCell.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/21/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    
    var recipe: Recipe? {
        didSet {
            print("Success")
            updateViews()
        }
    }
    @IBOutlet weak var recipeImageView: UIImageView!
    
    func updateViews() {
        if let recipeImageData = recipe?.image {
            recipeImageView.image = UIImage(data: recipeImageData) 
        } else {
            recipeImageView.image = UIImage(named: "AnneCelery")
        }
    }
}
