//
//  MealProvider.swift
//  JoyCo
//
//  Created by Cole Roberts on 11/1/23.
//

import Foundation

// MARK: - MealProvider -

protocol MealProvider {
    /// Returns an array of meals.
    /// - Parameter category: The category to filter, i.e. `Desserts`.
    /// - Returns: `[Meal]`
    func meals(for category: String) async throws -> [Meal]
    
    /// Returns a Recipe for the respective id.
    /// - Parameter category: The recipe identifier to lookup.
    /// - Returns: `Recipe`
    func recipe(for recipeId: String) async throws -> Recipe
}

// MARK: - RealMealProvider -

public final class RealMealProvider: MealProvider {
    
    // MARK: Private Properties
    
    private let networkService: any Service

    // MARK: Init
    
    init(
        networkService: any Service
    ) {
        self.networkService = networkService
    }

    // MARK: Public Methods

    func meals(for category: String) async throws -> [Meal] {
        let response: MealResponse<[Meal]> = try await networkService.request(.filter(category: category))
        return response.meals
    }
    
    func recipe(for recipeId: String) async throws -> Recipe {
        // This API returns an array of data when requesting a single recipe. We'll add some
        // debug assertions, and then take the first item, assuming it to be the requested resource.
        let response: MealResponse<[Recipe]> = try await networkService.request(.lookup(for: recipeId))
        assert(response.meals.count == 1)
        
        // In production code, it'd be worth exploring a more sane API, where a request that involves
        // fetching a single record, returns a single object, or providing some client-side checks for the array length,
        // safely taking the first element. Either way, for sake of this demo project, it seems reasonable to return the first element.
        return response.meals[0]
    }
}

// MARK: - Endpoint+Util -

fileprivate extension Endpoint {
    static func filter(category: String) -> Self{
        .api(
            path: "/filter.php",
            queryItems: [
                .init(name: "c", value: category)
            ],
            cachePolicy: .returnCacheDataElseLoad
        )
    }
    
    static func lookup(for recipeId: String) -> Self {
        .api(
            path: "/lookup.php",
            queryItems: [
                .init(name: "i", value: recipeId)
            ],
            cachePolicy: .returnCacheDataElseLoad
        )
    }
}
