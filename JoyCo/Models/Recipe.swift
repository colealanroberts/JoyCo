//
//  Recipe.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/30/23.
//

import Foundation

struct Recipe: Hashable {
    /// The unique identifier for a recipe.
    let identifier: String
    
    /// The displayable name for a recipe.
    let name: String
    
    /// The displayble instructions for a recipe.
    let instructions: String
    
    /// The ingredients that comrpise this recipe
    let ingredients: [Ingredient]
    
    /// The thumbnail url for a recipe.
    let thumbnailURL: String
}

// MARK: - Recipe+Ingredient -

extension Recipe {
    /// An ingredient represents both the consumable item and an exact
    /// measurement indicating the desired quantity.
    struct Ingredient: Hashable, Identifiable {
        /// A unique identifier for this ingredient.
        let id = UUID()
        
        /// The name of the ingredient.
        let name: String
        
        /// The measurement or quantity of the ingredient.
        /// For example, a recipe for Treacle Tart (id: `52892`) may call for the following —
        /// - Plain Flour (250g)
        /// - Butter (135g)
        /// - Lemons (Zest of 2)
        /// - ...
        let measurement: String
        
        /// The displayable text that reads naturally.
        /// i.e. `1 tsp Cinnamon`.
        var displayText: String {
            "\(measurement) \(name)"
        }
    }
}

// MARK: - Recipe+Decodables -

extension Recipe: Decodable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "idMeal"
        case name = "strMeal"
        case instructions = "strInstructions"
        case thumbnailURL = "strMealThumb"
        
        // The decision here to map each ingredient and measurement is deliberate. I briefly considered using `JSONSerialization`,
        // but eventually deciding against it, primarily in the name of Decodable conformance.
        case strIngredient1
        case strIngredient2
        case strIngredient3
        case strIngredient4
        case strIngredient5
        case strIngredient6
        case strIngredient7
        case strIngredient8
        case strIngredient9
        case strIngredient10
        case strIngredient11
        case strIngredient12
        case strIngredient13
        case strIngredient14
        case strIngredient15
        case strIngredient16
        case strIngredient17
        case strIngredient18
        case strIngredient19
        case strIngredient20
        
        case strMeasure1
        case strMeasure2
        case strMeasure3
        case strMeasure4
        case strMeasure5
        case strMeasure6
        case strMeasure7
        case strMeasure8
        case strMeasure9
        case strMeasure10
        case strMeasure11
        case strMeasure12
        case strMeasure13
        case strMeasure14
        case strMeasure15
        case strMeasure16
        case strMeasure17
        case strMeasure18
        case strMeasure19
        case strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.name = try container.decode(String.self, forKey: .name)
        self.instructions = try container.decode(String.self, forKey: .instructions)
        self.thumbnailURL = try container.decode(String.self, forKey: .thumbnailURL)
        
        // After looking through the MealDB API, several rules seem to apply to both the ingredient
        // and measurement lists.
        // - Each contain a prefix denoting their type, e.g. `strMeasureN` or `strIngredientN` where N is an int.
        // - The number of entries is never less than 1 or greater than 20, e.g. `strMeasure1` -> `strMeasure20`.
        // - The number of entries must be equal.
        //
        // We'll iterate through our prefixes, pairing the correct ingredient with the correct measurement.
        // First, we'll first set a lower and upper bound.
        let lowerBound = 1
        let upperBound = 20
        
        var ingredients = [Ingredient]()
        
        for index in lowerBound...upperBound {
            let ingredient = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strIngredient\(index)")!)
            let measurement = try container.decodeIfPresent(String.self, forKey: CodingKeys(rawValue: "strMeasure\(index)")!)
            
            // We'll need both a measure and an ingredient, each containing some content.
            guard let ingredient, !ingredient.isEmpty else { continue }
            guard let measurement, !measurement.isEmpty else { continue }
            
            let _ingredient = Ingredient(
                name: ingredient,
                measurement: measurement
            )
            
            ingredients.append(_ingredient)
        }
        
        self.ingredients = ingredients
    }
}
