//
//  Meal.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/30/23.
//

import Foundation

struct Meal: Hashable {
    /// The unique identifier for a meal.
    /// - Note: This property is used when performing recipe lookups from the `MealService`.
    let identifier: String
    
    /// The displayable name for a meal (unlocalized).
    let name: String
    
    /// The thumbnail url for a meal.
    let thumbnailURL: String
}

// MARK: - Meal+Identifiable -

extension Meal: Identifiable {
    /// Conform to `Identifiable` to ensure that SwiftUI is able to uniquely identify our models.
    var id: String { identifier }
}

// MARK: - Meal+Sortable -

extension Meal: Comparable {
    /// Conform to `Comparable` so we can sort alphabetically by the `name` field.
    static func < (lhs: Meal, rhs: Meal) -> Bool {
        lhs.name < rhs.name
    }
}

// MARK: - Meal+Decodable -

extension Meal: Decodable {
    private enum CodingKeys: String, CodingKey {
        case identifier = "idMeal"
        case name = "strMeal"
        case thumbnailURL = "strMealThumb"
    }
}
