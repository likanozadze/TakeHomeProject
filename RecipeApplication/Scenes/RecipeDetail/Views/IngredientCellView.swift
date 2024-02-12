//
//  IngredientCellView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import SwiftUI

// MARK: - IngredientCellView
struct IngredientCellView: View {
    
    // MARK: Properties
    var viewModel: RecipeDetailViewModel
    var ingredients: [ExtendedIngredient]
 //   @Binding var shoppingList: [ExtendedIngredient]
   // @State private var selectedIngredients: [Int: Bool] = [:]
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(viewModel.extendedIngredients, id: \.id) { ingredient in
                    
                    HStack {
                        Image(systemName: "circle.fill")
                            .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                            .font(.system(size: 18))
                      Text(ingredient.name)
                            .font(.system(size: 16))
                            .foregroundColor(.testColorSet)
                        
                        Spacer()
                        
                        HStack {
                            Text("\(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)")
                                .font(.system(size: 16))
                                .foregroundColor(.testColorSet)
                        }
                        
                        .foregroundStyle(.clear)
                        .frame(height: 30)
                        .cornerRadius(8)
                        Divider().background(Color.gray.opacity(0.2))
                    }
                }
            }
        }
    }
}
        // MARK: - ButtonView
//        ButtonView(isAnyItemSelected: .constant(selectedIngredients.values.contains(true)), selectedIngredients: $selectedIngredients, ingredients: ingredients, shoppingList: $shoppingList) 
//
//        }
//    }


