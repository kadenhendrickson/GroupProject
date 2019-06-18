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

    func addIngredient(name: String, measurement: String) {
        guard let recipe = recipe else {return}
        let ingredient = Ingredient(name: name, measurement: measurement)
        recipe.ingredients.append(ingredient)
    }
    func deleteIngredients(ingredient: Ingredient) {
        guard let indexOfIngredient = recipe?.ingredients.firstIndex(of: ingredient) else {return}
        recipe?.ingredients.remove(at: indexOfIngredient)
    }
    func updateIngredient(ingredient: Ingredient, name: String, measurement: String) {
        ingredient.name = name
        ingredient.measurement = measurement
    }
}
