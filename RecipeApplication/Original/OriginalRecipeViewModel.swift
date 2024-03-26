//
//  OriginalRecipeViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/21/24.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage


@MainActor
final class OriginalRecipeViewModel: ObservableObject {
    
    // MARK: - Properties
    
    @Published var ingredientsList = [String]()
    @Published var originalRecipes: [OriginalRecipesData] = []
    private let storage: Storage? = nil
    
    
    // MARK: - add Recipe
    
    func updateRecipeInfo(recipeData: OriginalRecipesData, image: UIImage?) async throws {
        do {
            guard let user = Auth.auth().currentUser else { return }
            if let image = image {
                uploadImageToFirebase(image: image, recipeId: recipeData.id)
            }
            let encodedRecipe = try Firestore.Encoder().encode(recipeData)
            try await Firestore.firestore().collection("users").document(user.uid).updateData([
                "recipes": FieldValue.arrayUnion([encodedRecipe])
            ])
            
            await getUserRecipes()
            
        } catch {
            throw error
        }
    }
    // MARK: - Add image
    
    private func uploadImageToFirebase(image: UIImage?, recipeId: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Storage.storage().reference(withPath: "\(uid)/recipes/recipe_\(recipeId)")
        guard let imageData = image?.jpegData(compressionQuality: 0.1) else { return }
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        ref.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("FATAL: Image upload failed: \(error)")
            } else {
                print("Image upload SUCCESS! Getting download URL...")
                ref.downloadURL { url, error in
                    
                    
                    if let error = error {
                        print("Failed to retrieve downloadURL: \(error)")
                        return
                    }
                    
                    if let downloadURL = url {
                        let userReference = Firestore.firestore().collection("users").document(uid)
                        
                        userReference.getDocument { document, error in
                            if let error = error {
                                print("Error fetching user document: \(error)")
                                return
                            }
                            
                            guard let document = document, document.exists else {
                                print("User document does not exist.")
                                return
                            }
                            
                            do {
                                let userData = try document.data(as: User.self)
                                var updatedRecipes: [OriginalRecipesData] = userData.recipes ?? []
                                if let index = updatedRecipes.firstIndex(where: { $0.id == recipeId }) {
                                    updatedRecipes[index].image = downloadURL.absoluteString
                                    userReference.updateData(["recipes": updatedRecipes.map { try? Firestore.Encoder().encode($0) }])
                                    
                                    self.objectWillChange.send()
                                } else {
                                    print("Recipe with ID \(recipeId) not found in the user's recipes array.")
                                }
                            } catch {
                                print("Error decoding user data: \(error)")
                            }
                        }
                    }
                    self.objectWillChange.send()
                }
            }
        }
    }
    
    
    func getUserRecipes() async {
        do {
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
            
            if let data = snapshot.data() {
                if let recipes = data["recipes"] as? [Any] {
                    self.originalRecipes = recipes.compactMap { try? Firestore.Decoder().decode(OriginalRecipesData.self, from: $0) }
                    print("Fetched \(self.originalRecipes.count) recipes")
                }
            }
        } catch {
            print("Error fetching user recipes: \(error)")
        }
    }
    
    func removeIngredient(item: String) {
        if let index = ingredientsList.firstIndex(of: item) {
            ingredientsList.remove(at: index)
        }
    }
    
    func deleteRecipe(recipeId: String) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let userData = document.data()
                var recipes = userData?["recipes"] as? [[String: Any]] ?? []
                
                recipes = recipes.filter { $0["id"] as? String != recipeId }
                
                userRef.updateData(["recipes": recipes]) { error in
                    if let error = error {
                        print("Error updating document: \(error)")
                    } else {
                        print("Recipe removed successfully")
                    }
                }
            } else {
                print("User document not found")
            }
        }
    }
}



//import Foundation
//import Firebase
//import FirebaseFirestore
//import FirebaseStorage
//
//@MainActor
//final class OriginalRecipeViewModel: ObservableObject {
//    
//    private let storage = Storage.storage()
//    private let firestore = Firestore.firestore()
//    private var userId: String?
//    
//    @Published var ingredientsList = [String]()
//    @Published var originalRecipes: [OriginalRecipesData] = []
//    
//    enum CustomError: Error {
//        case missingUserId
//        case imageConversionFailed
//        case firestoreUpdateFailed
//        // Add more specific error cases as needed
//    }
//
//    init() {
//        Auth.auth().addStateDidChangeListener { [weak self] _, user in
//            self?.userId = user?.uid
//            self?.fetchRecipes()
//        }
//    }
//    
//    func addIngredient(_ ingredient: String) {
//        ingredientsList.append(ingredient)
//    }
//    
//    func removeIngredient(item: String) {
//        ingredientsList.removeAll(where: {$0 == item })
//    }
//    
//    func updateRecipeInfo(recipeData: OriginalRecipesData, image: UIImage?, completion: ((Error?) -> Void)? = nil) {
//        guard let userId = userId else {
//            completion?(CustomError.missingUserId)
//            return
//        }
//        
//        if let image = image {
//            uploadImage(image, recipeId: recipeData.id) { [weak self] error in
//                self?.updateFirestoreRecipe(recipeData: recipeData, error: error, completion: completion)
//            }
//        } else {
//            updateFirestoreRecipe(recipeData: recipeData, error: nil, completion: completion)
//        }
//    }
//    
//    func deleteRecipe(recipeId: String, completion: ((Error?) -> Void)? = nil) {
//        guard let userId = userId else {
//            completion?(CustomError.missingUserId)
//            return
//        }
//        let db = Firestore.firestore()
//        let userRef = db.collection("users").document(userId)
//        
//        userRef.updateData([
//            "recipes": FieldValue.arrayRemove([["id": recipeId]]) // Remove recipe with matching ID
//        ]) { error in
//            if let error = error {
//                completion?(error)
//            } else {
//                print("Recipe removed successfully")
//                completion?(nil)
//            }
//        }
//    }
//    
//    // MARK: - Helpers
//    
//     func fetchRecipes() {
//        guard let userId = userId else { return }
//        
//        firestore.collection("users").document(userId).getDocument { [weak self] snapshot, error in
//            if let error = error {
//                print("Error fetching user recipes: \(error)")
//            } else if let snapshot = snapshot, let data = snapshot.data(), let recipes = data["recipes"] as? [[String: Any]] {
//                do {
//                    let decodedRecipes = try recipes.map { try Firestore.Decoder().decode(OriginalRecipesData.self, from: $0)}
//                    self?.originalRecipes = decodedRecipes
//                } catch {
//                    print("Error decoding recipes: \(error)")
//                }
//            } else {
//                print("User document or recipes data not found.")
//            }
//        }
//    }
//    
//    private func uploadImage(_ image: UIImage, recipeId: String, completion: @escaping (Error?) -> Void) {
//        guard let userId = userId else {
//            completion(CustomError.missingUserId)
//            return
//        }
//        
//        let ref = Storage.storage().reference(withPath: "\(userId)/recipes/recipe_\(recipeId)")
//        guard let imageData = image.jpegData(compressionQuality: 0.1) else {
//            completion(CustomError.imageConversionFailed)
//            return
//        }
//        
//        ref.putData(imageData, metadata: nil) { metadata, error in
//            completion(error) // Pass along any Storage upload error
//        }
//    }
//    
//    
//    private func updateFirestoreRecipe(recipeData: OriginalRecipesData, error: Error?, completion: ((Error?) -> Void)? = nil) {
//        guard let userId = userId else {
//            completion?(CustomError.missingUserId)
//            return
//        }
//        
//        do {
//            let encodedRecipe = try Firestore.Encoder().encode(recipeData)
//            firestore.collection("users").document(userId).updateData([
//                "recipes": FieldValue.arrayUnion([encodedRecipe])
//            ]) { updateError in
//                completion?(updateError ?? error) // Prioritize Firestore errors
//            }
//        } catch {
//            completion?(error)
//        }
//    }
//}
