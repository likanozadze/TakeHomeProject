//
//  RecipeDetailView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import SwiftUI

struct RecipeDetailView: View {
    
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var selectedSegment: String = "Ingredients"
    
    var body: some View {
        VStack(spacing: 10) {
            ProductView(recipe: viewModel.recipe)
            Spacer()
            if let selectedIngredient = viewModel.selectedIngredient {
                IngredientDetailView(ingredient: selectedIngredient)
            } else {
                PickerView(selectedSegment: $selectedSegment)
                if selectedSegment == "Ingredients" {
                    IngredientCellView(ingredients: viewModel.extendedIngredients)
                    ButtonView()
                } else {
                    DirectionCellView(recipe: viewModel.recipe, analyzedInstructions: viewModel.analyzedInstructions)

                }
            }
        }
        .padding()
    }
}
