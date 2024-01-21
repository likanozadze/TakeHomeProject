//
//  LoginViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/21/24.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func showInvalidEmailAlert()
    func showInvalidPasswordAlert()
    func showSignInErrorAlert(with error: String)
    func authenticationSuccessful()
}

class LoginViewModel {
    
    weak var delegate: LoginViewModelDelegate?
    
    func signIn(email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let loginRequest = LoginUserRequest(email: email, password: password)
        
        
        // Email check
        if !Validator.isValidEmail(for: loginRequest.email) {
            delegate?.showInvalidEmailAlert()
            return
        }
        
        // Password check
        if !Validator.isPasswordValid(for: loginRequest.password) {
            delegate?.showInvalidPasswordAlert()
            return
        }
        
        AuthService.shared.signIn(with: loginRequest) { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                self.delegate?.showSignInErrorAlert(with: error.localizedDescription)
            } else {
                self.delegate?.authenticationSuccessful()
            }
        }
    }
}
