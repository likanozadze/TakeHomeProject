//
//  ShoppingList.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 4/29/24.
//

import SwiftUI

struct ShoppingListView: View {
  
    @StateObject var shoppingListViewModel = ShoppingListViewModel.shared
    
    var body: some View {
        ZStack {
            if ShoppingListViewModel.shared.shoppingList.isEmpty {
                
                Text("add items to your shopping list")
                    .font(.title)
                
            } else {
                List {
                    Text("Items to purchase")
                    ForEach(ShoppingListViewModel.shared.shoppingList) { ingredient in
                        HStack {
                            Image(systemName: "square.fill")
                                .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                                .font(.system(size: 18))
                            Text(ingredient.name)
                                .foregroundColor(.testColorSet)
                            Spacer()
                            Text("\(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)")
                                .foregroundColor(.testColorSet)
                        }
                      
                        .cornerRadius(8)
                    }
                    .onDelete(perform: deleteIngredient)
                }
                              .onAppear {
                    Task {
                        await shoppingListViewModel.loadShoppingList()
                    }
                }
            }
        }
    }
    

    private func deleteIngredient(at offsets: IndexSet) {
        ShoppingListViewModel.shared.shoppingList.remove(atOffsets: offsets)
    }
}
