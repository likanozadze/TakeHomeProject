//
//  UserManager.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/23/24.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: - User Manager
final class UserManager {
   
  // MARK: - Singleton Reference
  static let shared = UserManager()
   
  // MARK: - Init
  private init() { }
   
  // MARK: - Collection References
  private let userCollection = Firestore.firestore().collection("users")
  private let originalRecipesCollection = Firestore.firestore().collection("original_recipes")
    
   
  // MARK: - User Document
  private func userDocument(userId: String) -> DocumentReference {
    userCollection.document(userId)
  }
   
  // MARK: - Create New User Firestore
  func createNewUser(user: User) async throws {
    try userDocument(userId: user.id).setData(from: user, merge: false)
  }
   
  // MARK: - Get User From Firestore
  func getUser(userId: String) async throws -> User {
    try await userDocument(userId: userId).getDocument(as: User.self)
  }
   
  // MARK: - Upload Original Recipes Firestore
  func uploadOriginalRecipes(userId: String, recipes: [OriginalRecipesData]) async throws {
    var recipesData: [[String: Any]] = []
     
    for recipe in recipes {
      let recipeData: [String: Any] = [
        "name": recipe.name ,
        "image": recipe.image,
        "time": recipe.time,
        "ingredients": recipe.ingredients,
        "recipe": recipe.recipe
      ]
      recipesData.append(recipeData)
    }
     
    let data: [String: Any] = ["recipes": recipesData]
     
    try await userDocument(userId: userId).setData(data, merge: true)
  }
   
  // MARK: - Get Original Recipes for User
  func getOriginalRecipes(userId: String) async throws -> [OriginalRecipesData] {
    let document = userDocument(userId: userId)
    let documentSnapshot = try await document.getDocument()
     
    guard let data = try? documentSnapshot.data(as: User.self) else {
      throw NSError(domain: "YourErrorDomain", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user data."])
    }
     
    return data.recipes ?? []
  }
   
}

struct User: Identifiable, Codable {
  let id: String
  var username: String
  var email: String
  let recipes: [OriginalRecipesData]?
  let likedRecipes: [String]?
}

struct OriginalRecipesData: Codable {
  let id: String
  let name: String
  var image: String
  let time: Int
  let ingredients: [String]
  let recipe: String
}
