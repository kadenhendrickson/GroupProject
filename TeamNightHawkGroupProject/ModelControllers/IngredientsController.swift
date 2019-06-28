//
//  IngredientsController.swift
//  TeamNightHawkGroupProject
//
//  Created by Kaden Hendrickson on 6/18/19.
//  Copyright © 2019 DevMountain. All rights reserved.
//

import Foundation

class IngredientsController {
    
    static let shared = IngredientsController()
    var recipe: Recipe?
    
    func addIngredient(name: String, measurementName: String, measurementQuantity: String) {
        guard let recipe = recipe else {return}
        let ingredient = Ingredient(name: name, measurementName: measurementName, measurementQuantity: measurementQuantity)
        recipe.ingredients.append(ingredient.ingredientDictionary)
    }
    func 🏘(ingredient: Ingredient) {
        guard let indexOfIngredient = recipe?.ingredients.firstIndex(of: ingredient) else {return}
        recipe?.ingredients.remove(at: indexOfIngredient)
    }
    func updateIngredient(ingredient: Ingredient, name: String, measurementName: String, measurementQuantity: String) {
        ingredient.name = name
        ingredient.measurementName = measurementName
        ingredient.measurementQuantity = measurementQuantity
    }
}
