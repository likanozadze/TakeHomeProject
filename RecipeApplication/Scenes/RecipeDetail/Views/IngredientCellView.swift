////
////  IngredientCellView.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/30/24.
////
//
import SwiftUI

struct IngredientCellView: View {
    
    // MARK: Properties
    var viewModel: RecipeDetailViewModel
    var ingredients: [ExtendedIngredient]
    @Binding var shoppingList: [ExtendedIngredient]
    @State private var selectedIngredients: [Int: Bool] = [:]
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                ForEach(viewModel.extendedIngredients, id: \.id) { ingredient in
                    
                    HStack {
                        Image(systemName: selectedIngredients[ingredient.id, default: false] ? "checkmark.square" : "square")
                            .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                            .font(.system(size: 25))
                        
                        Text(ingredient.name)
                            .font(.system(size: 16))
                            .foregroundColor(.testColorSet)
                            .foregroundColor(selectedIngredients[ingredient.id, default: false] ? .gray : .testColorSet)
                            .strikethrough(selectedIngredients[ingredient.id, default: false], color: .black)
                        Spacer()
                        
                        HStack {
                            Text("\(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)")
                                .font(.system(size: 16))
                                .foregroundColor(.testColorSet)
                        }
                    }
                    .foregroundStyle(.clear)
                    .frame(height: 30)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedIngredients[ingredient.id, default: false].toggle()
                    }
                    Divider().background(Color.gray.opacity(0.2))
                }
            }
        }
    }
}
