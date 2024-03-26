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
    
    @Published var userSession: FirebaseAuth.User?
    
    /// A method to register the user
    /// - Parameters:
    ///   - userRequest: The users information (email, password, username)
    ///   - completion: A completion with two values...
    ///   - Bool: wasRegistered - Determines if the user was registered and saved in the database correctly
    ///   - Error?: An optional error if firebase provides once
//        public func registerUser(with userRequest: RegisterUserRequest, completion:
//                                 @escaping (Bool, Error?)->Void) {
//            let username = userRequest.username
//            let email = userRequest.email
//            let password = userRequest.password
//            
//            Auth.auth().createUser(withEmail: email, password: password) { result, error in
//                if let error = error {
//                    completion(false, error)
//                    return
//                }
//                
//                guard let resultUser = result?.user else {
//                    completion(false, nil)
//                    return
//                }
//                
//                let dataBase = Firestore.firestore()
//                dataBase.collection("users")
//                    .document(resultUser.uid)
//                    .setData([
//                        "username": username,
//                        "email": email
//                    ]) { error in
//                        if let error = error {
//                            completion(false, error)
//                            return
//                        }
//                        
//                        completion(true, nil)
//                    }
//            }
//        }
//    public func registerUser(with userRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
//        Task {
//            do {
//                let result = try await Auth.auth().createUser(withEmail: userRequest.email, password: userRequest.password)
//                //                completion(true, nil)  // Success
//                //                      } catch {
//                //                          completion(false, error)
//                //            }
//                //
//                //            guard let resultUser = result?.user else {
//                //                completion(false, nil)
//                //                return
//                //            }
//                //
//                self.userSession = result.user
//                let user = DBUser(id: result.user.uid,
//                                  fullname: userRequest.username,
//                                  email: userRequest.email,
//                                  recipes: [],
//                                  likedRecipes: [])
//
//                do {
//                    let encodedUser = try Firestore.Encoder().encode(user)
//                    try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
//                    completion(true, nil)  // Success!
//                } catch {
//                    completion(false, error)
//                }
//            }
//        }
//    }
    
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

//
//    
//    
//    public func registerUser(with registerRequest: RegisterUserRequest, completion: @escaping (Bool, Error?) -> Void) {
//        Auth.auth().createUser(withEmail: registerRequest.email, password: registerRequest.password) { authResult, error in
//            if let error = error {
//                completion(false, error)
//                return
//            }
//            
//            guard let userId = authResult?.user.uid else {
//                completion(false, nil)
//                return
//            }
//            
//            let db = Firestore.firestore()
//            db.collection("users").document(userId).setData([
//                "username": registerRequest.username,
//                "email": registerRequest.email,
//                "recipes": registerRequest.recipes ?? "",
//                "likedRecipes": registerRequest.likedRecipes ?? ""
//            ]) { error in
//                completion(error == nil, error)
//            }
//        }
//    }
    
//    
    // MARK: - UserSignIn
    
    public func signIn(with userRequest: LoginUserRequest, completion: @escaping (Error?)->Void) {
        Auth.auth().signIn(
            withEmail: userRequest.email,
            password: userRequest.password
        ) { result, error in
            if let error = error {
                completion(error)
                return
            } else {
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
