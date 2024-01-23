//
//  RegisterViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/23/24.
//

import Foundation

protocol RegisterViewModelDelegate: AnyObject {
    
    func showInvalidEmailAlert()
    func showInvalidPasswordAlert()
    func showInvalidUsernameAlert()
    func showRegistrationErrorAlert(message: String?)
    func checkAuthentication()
}

final class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?
    
    // MARK: - Properties
    
    var coordinator: NavigationCoordinator?
    
    // MARK: - Public Methods
    
    func signUp(username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let registerUserRequest = RegisterUserRequest(username: username, email: email, password: password)
        
        if !Validator.isValidUsername(for: registerUserRequest.username) {
            delegate?.showInvalidUsernameAlert()
            return
        }
        
        if !Validator.isValidEmail(for: registerUserRequest.email) {
            delegate?.showInvalidEmailAlert()
            return
        }
        
        if !Validator.isPasswordValid(for: registerUserRequest.password) {
            delegate?.showInvalidPasswordAlert()
            return
        }
        
        AuthService.shared.registerUser(with: registerUserRequest) { [weak self] wasRegistered, error in
            guard let self = self else { return }
            
            if let error = error {
                let errorMessage = "Registration Error: \(error.localizedDescription)"
                self.delegate?.showRegistrationErrorAlert(message: errorMessage)
                completion(false, error)
                return
            }
            
            if wasRegistered {
                self.coordinator?.start()
                completion(true, nil)
            } else {
                let errorMessage = "Unknown Registration Error"
                self.delegate?.showRegistrationErrorAlert(message: errorMessage)
                completion(false, nil)
            }
        }
    }
}
