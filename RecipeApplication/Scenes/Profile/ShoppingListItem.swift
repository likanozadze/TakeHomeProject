//
//  ShoppingListItem.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/7/24.
//

import SwiftUI

//
//struct ShoppingListItem {
//    let ingredient: [ExtendedIngredient]
//    let title: String
//    let name: String
//    let amount: Double
//    let unit: String
//    
//}
//class ShoppingListStore: ObservableObject {
//    @Published var items: [ExtendedIngredient] = []
//}
//class ShoppingListStore: ObservableObject {
//    @Published var shoppingList: [ExtendedIngredient] = []
//}


//class ShoppingList {
//    static let shared = ShoppingList()
//    var items = [ExtendedIngredient]()
//    
//    private init(){}
//}
    
//    init(items: [ExtendedIngredient]) {
//        self.items = items
//    }

class ShoppingListViewModel: ObservableObject {
    @Published var shoppingList: [ExtendedIngredient] = []
}
