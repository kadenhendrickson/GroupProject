//
//  ExploreCollectionViewController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/19/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import UIKit

private let reuseIdentifier = "exploreRecipeCell"

private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

private let itemsPerRow: CGFloat = 3

class ExploreCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    //MARK: - Properties
    var recipesList: [Recipe] {
        var recipes: [Recipe] = []
        for (_, recipe) in RecipeController.shared.recipes {
            recipes.append(recipe)
        }
        return recipes
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        
        // Do any additional setup after loading the view.
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("clicked")
        if segue.identifier == "fromExploreToRecipeDVC" {
            guard let indexPath = collectionView.indexPathsForSelectedItems,
                let destinationVC = segue.destination as? RecipeDetailTableViewController else {return}
            let recipe = recipesList[indexPath[0].row]
            destinationVC.recipe = recipe
        }
      
    }
    

    // MARK: UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipesList.count
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "exploreRecipeCell", for: indexPath) as? ExploreCollectionViewCell else {print("This problem is the big dumb");return UICollectionViewCell()}
        
        let recipe = recipesList[indexPath.row]
        cell.backgroundColor = .white
        cell.recipe = recipe
         
        return cell
    }

    // MARK: UICollectionViewDelegate




    
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
        
    
    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "<#T##String#>", sender: <#T##Any?#>)
//    }
    

}

// MARK: - Collection View Flow Layout Delegate
extension ExploreCollectionViewController {
    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }

    
}
