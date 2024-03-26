//
//  AuthServiceModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/23/24.
//
//
//import Foundation
//import FirebaseAuth
//
//struct AuthDataResultModel {
//    let uid: String
//   let email: String?
//
//    init(user: User) {
//        self.uid = user.uid
//        self.email = user.email
//    
//    }
//}
//
//final class AuthenticationManager {
//    // MARK: - Singleton
//    static let shared = AuthenticationManager()
//    
//    // MARK: - Init
//    private init() { }
//    
//    func signInUser(email: String, password: String) async throws -> AuthDataResultModel {
//        
//        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
//        return AuthDataResultModel(user: authDataResult.user)
//    }
//    
//    // MARK: - Create User on Firebase
//    func createUser(email: String, password: String) async throws -> AuthDataResultModel {
//        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        return AuthDataResultModel(user: authDataResult.user)
//    }
//    
//    // MARK: - Get User from Firebase
//    func getAuthenticatedUser() async throws ->  AuthDataResultModel {
//        guard let user = Auth.auth().currentUser else {
//            throw URLError(.badServerResponse)
//        }
//        
//        return AuthDataResultModel(user: user)
//    }
//    
//    func signOut() throws {
//        
//        try Auth.auth().signOut()
//    }
//    
//    func isUserLoggedIn() -> Bool {
//        
//        return Auth.auth().currentUser != nil
//    }
//}
