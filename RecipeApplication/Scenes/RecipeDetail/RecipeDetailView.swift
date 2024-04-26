//
//  RecipeDetailView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.

import SwiftUI

// MARK: - RecipeDetailView
struct RecipeDetailView: View {
    
    // MARK: - Properties
    @ObservedObject var viewModel: RecipeDetailViewModel
    @EnvironmentObject var shoppingListViewModel: ShoppingListViewModel
    @State private var selectedSegment: String = "Ingredients"

    // MARK: - Initializer
    init(viewModel: RecipeDetailViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Body
    var body: some View {
        VStack(spacing: 10) {
            // MARK: - ProductView
            ProductView(recipe: viewModel.recipe)
            Spacer()
            if let selectedIngredient = viewModel.selectedIngredient {
                // MARK: - IngredientDetailView
                IngredientDetailView(ingredient: selectedIngredient)
            } else {

                // MARK: - PickerView
                PickerView(selectedSegment: $selectedSegment, filterOptions: ["Ingredients", "Instructions"])
                if selectedSegment == "Ingredients" {
                    // MARK: - IngredientCellView
                    IngredientCellView(viewModel: viewModel, ingredients: viewModel.extendedIngredients, shoppingList: $shoppingListViewModel.shoppingList)

                } else {
                    // MARK: - StepsSectionView
                    StepsSectionView(steps: viewModel.analyzedInstructions)              
                }
            }
        }
        .padding()
    }
}
