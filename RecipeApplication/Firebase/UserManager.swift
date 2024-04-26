//
//  UserManager.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/23/24.


import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseAuth
// MARK: - User Manager
final class UserManager: ObservableObject {
    
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
    
    func updateShoppingList(userId: String, shoppingList: [ExtendedIngredient]) async throws {
        do {
            let shoppingListData = try JSONEncoder().encode(shoppingList)
            guard let shoppingListString = String(data: shoppingListData, encoding: .utf8) else {
                throw ShoppingListError.encodingError
            }
            let data: [String: Any] = ["shoppingList": shoppingListString]
            try await userDocument(userId: userId).setData(data, merge: true)
        } catch  _ as EncodingError {
            throw ShoppingListError.encodingError
        } catch let firestoreError {
            throw ShoppingListError.firestoreError(firestoreError)
        }
    }
    
    func fetchShoppingList(userId: String) async throws -> [ExtendedIngredient] {
        let documentSnapshot = try await userDocument(userId: userId).getDocument()
        
        if let shoppingListString = documentSnapshot.get("shoppingList") as? String {
            guard let shoppingListData = shoppingListString.data(using: .utf8) else {
                throw ShoppingListError.decodingError
            }
            do {
                return try JSONDecoder().decode([ExtendedIngredient].self, from: shoppingListData)
            } catch {
                throw ShoppingListError.decodingError
            }
        } else {
            return []
        }
    }
    func uploadProfileImage(userId: String, image: UIImage, completion: @escaping (Error?) -> Void) {
        print("User ID: \(userId)")
        if let user = Auth.auth().currentUser {
            print("Authenticated as: \(user.uid)")
        } else {
            print("Error: No user is authenticated")
            return
        }

        print("Storage Path: \(Storage.storage().reference().child("profile_images/\(userId).jpg").fullPath)")
        
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            print("Failed to convert image to data")
            completion(ImageError.failedToConvertToData)
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")  
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading profile image: \(error)")
                completion(error)
            } else {
                print("Profile image uploaded successfully")
                completion(nil)
            }
        }
    }

    
    func downloadProfileImage(userId: String, completion: @escaping (UIImage?, Error?) -> Void) {
        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")
        
        storageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                completion(nil, error)
            } else if let data = data, let image = UIImage(data: data) {
                completion(image, nil)
            } else {
                completion(nil, ImageError.failedToConvertToImage)
            }
        }
    }
    enum ImageError: Error {
        case failedToConvertToData
        case failedToConvertToImage
    }
    
}



struct User: Identifiable, Codable {
    let id: String
    var username: String
    var email: String
    let recipes: [OriginalRecipesData]?
    let likedRecipes: [String]?
    var shoppingListString: String?
    var profilePictureURL: String?
}

enum ShoppingListError: Error {
    case encodingError
    case decodingError
    case firestoreError(Error)
}

struct OriginalRecipesData: Codable {
    let id: String
    let name: String
    var image: String
    let time: Int
    let ingredients: [String]
    let recipe: String
    
}
