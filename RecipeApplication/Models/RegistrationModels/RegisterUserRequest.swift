//
//  RegisterUserRequest.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/21/24.
//

import Foundation

struct RegisterUserRequest: Codable {
    let username: String
    let email: String
    let password: String
    let id: String
    let recipes: [OriginalRecipesData]?
    let likedRecipes: [String]?
}
