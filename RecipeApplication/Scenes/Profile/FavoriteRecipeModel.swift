//
//  FavoriteRecipeModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/2/24.
//


import Foundation
import UIKit

struct FavoriteRecipeModel {
    
    // MARK: - Properties
    static var favoriteRecipe = [Recipe]()
    
    // MARK: - Methods
    mutating func favoriteNewRecipes(_ recipeResponse: Recipe) {
        if FavoriteRecipeModel.favoriteRecipe.isEmpty {
            FavoriteRecipeModel.favoriteRecipe = [recipeResponse]
        } else if FavoriteRecipeModel.favoriteRecipe.contains(where: { $0.id == recipeResponse.id }) {
            return
        } else {
            FavoriteRecipeModel.favoriteRecipe.append(recipeResponse)
        }
    }
    
    mutating func deleteFavoriteRecipe(_ recipeResponse: Recipe) {
        let recipeID = recipeResponse.id
        FavoriteRecipeModel.favoriteRecipe.removeAll(where: { $0.id == recipeID })
    }
    
    func getFavoriteRecipeList() -> [Recipe] {
        FavoriteRecipeModel.favoriteRecipe
    }
    
    func isRecipeFavorited(recipeID: Int) -> Bool {
        FavoriteRecipeModel.favoriteRecipe.contains(where: { $0.id == recipeID })
    }
    func setFavoriteButtonImage(button: UIButton, recipeID: Int) {
        if isRecipeFavorited(recipeID: recipeID) {
            button.isSelected = true
            button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        } else {
            button.isSelected = false
            button.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
}
