//
//  ShoppingListItem.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/7/24.
//

import SwiftUI


struct ShoppingListItem {
    let ingredient: [ExtendedIngredient]
    let title: String
    let name: String
    let amount: Double
    let unit: String
    
}
class ShoppingListStore: ObservableObject {
    @Published var items: [ExtendedIngredient] = []
}
