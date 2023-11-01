//
//  DetailView.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/31/23.
//

import SwiftUI

struct DetailView: View {
    
    // MARK: Private Properties
    
    private let mealName: String
    private let viewModel: ViewModel
    
    // MARK: Init
    
    init(
        meal: Meal,
        mealProvider: any MealProvider
    ) {
        self.mealName = meal.name
        self.viewModel = .init(
            mealId: meal.identifier,
            mealProvider: mealProvider
        )
    }
    
    // MARK: Body
    
    var body: some View {
        NavigationStack {
            ScrollView {
                switch viewModel.state {
                case .error(let error):
                    ErrorView(
                        text: error.localizedDescription,
                        action: .init(
                            title: "Retry",
                            onTap: {
                                viewModel.send(.fetchRecipe)
                            }
                        )
                    )
                case .loading:
                    ProgressView().padding()
                case .loaded(let recipe):
                    RecipeView(recipe: recipe)
                }
            }
        }
        .task {
            viewModel.send(.fetchRecipe)
        }
    }
}

// MARK: - DetailView+ViewModel -

fileprivate extension DetailView {
    @Observable final class ViewModel {
        
        // MARK: Public Properties
        
        private(set) var state: Loadable<Recipe> = .loading
        
        // MARK: Private Properties
        
        private let mealId: String
        private let mealProvider: any MealProvider
        
        // MARK: Init
        
        init(
            mealId: String,
            mealProvider: any MealProvider
        ) {
            self.mealId = mealId
            self.mealProvider = mealProvider
        }
    }
}

// MARK: - DetailView.ViewModel+Actionable -

extension DetailView.ViewModel: Actionable {
    enum Action {
        /// Attempts to fetch an associated `Recipe` by identifier.
        case fetchRecipe
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchRecipe:
            Task {
                do {
                    if !state.isLoading {
                        state = .loading
                    }
                    let recipe = try await mealProvider.recipe(for: mealId)
                    state = .loaded(recipe)
                } catch {
                    state = .error(error)
                }
            }
        }
    }
}
