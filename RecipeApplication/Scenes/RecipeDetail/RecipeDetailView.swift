//
//  RecipeDetailView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.

import SwiftUI

struct RecipeDetailView: View {
    
    @ObservedObject var viewModel: RecipeDetailViewModel
    @State private var selectedSegment: String = "Ingredients"
    
    init(viewModel: RecipeDetailViewModel) {
           self.viewModel = viewModel
       }
    
    var body: some View {
        VStack(spacing: 10) {
            ProductView(recipe: viewModel.recipe)
            Spacer()
            if let selectedIngredient = viewModel.selectedIngredient {
                IngredientDetailView(ingredient: selectedIngredient)
            } else {
                PickerView(selectedSegment: $selectedSegment)
                if selectedSegment == "Ingredients" {
                    IngredientCellView(viewModel: viewModel, ingredients: viewModel.extendedIngredients)
                    ButtonView()
                } else {
                    StepsSectionView(steps: viewModel.analyzedInstructions)
              
                }
            }
        }
        .padding()
    }
}
