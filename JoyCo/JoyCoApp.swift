//
//  JoyCoApp.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/30/23.
//

import SwiftUI

@main
struct JoyCoApp: App {
    
    // MARK: - Private Properties -
    
    private let mealProvider: any MealProvider
    
    // MARK: - Init -
    
    init() {
        let networkService = NetworkService(
            decoder: JSONDecoder(),
            urlSession: .shared
        )
        
        self.mealProvider = RealMealProvider(
            networkService: networkService
        )
    }
    
    // MARK: - Body -
    
    var body: some Scene {
        WindowGroup {
            HomeView(mealProvider: mealProvider)
        }
    }
}
