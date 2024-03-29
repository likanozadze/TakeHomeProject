//
//  AuthService.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/21/24.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

class AuthService {
    
    
    // MARK: - Singleton Instance
    
    public static let shared = AuthService()
    private init() {}
    public var onUserSignedIn: (([OriginalRecipesData]) -> Void)?

    
    @Published var userSession: FirebaseAuth.User?
    

    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
        Task {
            do {
                let result = try await Auth.auth().createUser(withEmail: userRequest.email, password: userRequest.password)
                self.userSession = result.user
                let user = User(id: result.user.uid,
                                username: userRequest.username,
                                email: userRequest.email,
                                recipes: [],
                                likedRecipes: [])
                
                do {
                     let encodedUser = try Firestore.Encoder().encode(user)
                     try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
                     completion(true, nil)
                } catch {
                     completion(false, error)
                }
           } catch {
                completion(false, error)
          }
       }
    }


    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
        ) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
             
                guard let result = result else {
                    completion(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "No auth result"]))
                    return
                }
                Task {
                    do {
                        let user = try await UserManager.shared.getUser(userId: result.user.uid)
                        self.userSession = result.user
                        if let recipes = user.recipes {
                            self.onUserSignedIn?(recipes) 
                        }
                    } catch {
                        print("Failed to fetch user data: \(error)")
                    }
                }
                completion(nil)
            }
        }
    }


    // MARK: - UserSignOut
    public func signOut(completion: @escaping (Error?)->Void) {
        do {
            try Auth.auth().signOut()
            completion(nil)
        } catch let error {
            completion(error)
        }
    }
}
