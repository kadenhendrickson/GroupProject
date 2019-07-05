//
//  IngredientsController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class IngredientsController {
    
    //MARK: - Singleton
    static let shared = IngredientsController()
    //MARK: - Properties
    var recipe: Recipe?
    
    //MARK: - CRUD Funtions
    
    func addIngredient(name: String, measurementName: String, measurementQuantity: String) {
        guard let recipe = recipe else {return}
        let ingredient = Ingredient(name: name, measurementName: measurementName, measurementQuantity: measurementQuantity)
        recipe.ingredients.append(ingredient)
    }
    
    func updateIngredient(ingredient: Ingredient, name: String, measurementName: String, measurementQuantity: String) {
        ingredient.name = name
        ingredient.measurementName = measurementName
        ingredient.measurementQuantity = measurementQuantity
    }
}
