//
//  HomeView.swift
//  JoyCo
//
//  Created by Cole Roberts on 10/30/23.
//

import Combine
import SwiftUI

struct HomeView: View {
    
    // MARK: Private Properties
    
    @Bindable private var viewModel: ViewModel
    private let mealProvider: any MealProvider
    
    // MARK: Init
    
    init(
        mealProvider: any MealProvider
    ) {
        self.mealProvider = mealProvider
        self.viewModel = .init(mealProvider: mealProvider)
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
                                viewModel.send(.fetchMeals)
                            }
                        )
                    )
                case .loading:
                    ProgressView().padding()
                case .loaded(let meals):
                    if meals.isEmpty {
                        Text("No content.")
                    } else {
                        ForEach(meals) { meal in
                            MealCell(
                                meal: meal,
                                onTap: { meal in
                                    viewModel.send(.presentDetailView(meal))
                                }
                            )
                        }
                    }
                }
            }
            .sheet(item: $viewModel.isPresentingDetailView) { meal in
                DetailView(
                    meal: meal,
                    mealProvider: mealProvider
                )
            }
            .navigationTitle("Menu")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            viewModel.send(.fetchMeals)
        }
    }
}

// MARK: - HomeView+ViewModel -

fileprivate extension HomeView {
    @Observable final class ViewModel {
        
        // MARK: Public Properties

        var isPresentingDetailView: Meal?
        private(set) var state: Loadable<[Meal]> = .loading
        
        // MARK: Private Properties
        
        private let mealProvider: any MealProvider
        
        // MARK: Init
        
        init(
            mealProvider: any MealProvider
        ) {
            self.mealProvider = mealProvider
        }
    }
}

// MARK: - HomeView.ViewModel+Actionable -

extension HomeView.ViewModel: Actionable {
    enum Action {
        /// Attempts to fetch an array of `[Meal]` from the
        /// recipe service.
        case fetchMeals
        
        /// Present the detail view for a recipe
        case presentDetailView(Meal)
    }
    
    func send(_ action: Action) {
        switch action {
        case .fetchMeals:
            Task {
                do {
                    if !state.isLoading {
                        state = .loading
                    }
                    let meals = try await mealProvider.meals(for: "Dessert")
                    state = .loaded(meals)
                } catch {
                    state = .error(error)
                }
            }
        case .presentDetailView(let meal):
            isPresentingDetailView = meal
        }
    }
}
