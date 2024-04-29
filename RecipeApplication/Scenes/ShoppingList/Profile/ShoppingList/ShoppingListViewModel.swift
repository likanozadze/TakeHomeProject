//
//  ShoppingListViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 4/29/24.
//

import Foundation
import Firebase
import FirebaseFirestore

class ShoppingListViewModel: ObservableObject {
    @Published var shoppingList: [ExtendedIngredient] = []
    
    static let shared = ShoppingListViewModel()
    private var isLoading = false
    
    private let userManager = UserManager.shared
    private let authService = AuthService.shared
   
    
    
    init() {
        print("ShoppingListViewModel initialized")
        setupFirestoreListener()
        Task { await loadShoppingList() }
    }
    
    private func setupFirestoreListener() {
        
        guard let userId = authService.userSession?.uid else { return }
        Firestore.firestore().collection("users").document(userId)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error setting up Firestore listener: \(error)")
                } else if snapshot != nil {
                    
                }
            }
    }
    func saveShoppingList(ingredients: [ExtendedIngredient]) async {
        guard let currentUserId = authService.userSession?.uid else { return }
        do {
            try await userManager.updateShoppingList(userId: currentUserId, shoppingList: ingredients)
            print("Shopping List saved remotely:", ingredients)
        } catch {
            print("Error saving shopping list remotely: \(error)")
        }
    }

    func loadShoppingList() async {
        print("loadShoppingList called")
        defer { isLoading = false }
        guard let currentUserId = authService.userSession?.uid else {
            print("No current user ID")
            return
        }
        isLoading = true
        
        do {
            print("Attempting to load shopping list for user \(currentUserId)")
            let loadedShoppingList = try await userManager.fetchShoppingList(userId: currentUserId)
            DispatchQueue.main.async {
                self.shoppingList = loadedShoppingList
                print("Shopping list loaded: \(self.shoppingList)")
            }
        } catch {
            print("Error loading shopping list: \(error)")
        }
    }

}
