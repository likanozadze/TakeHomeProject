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
    func updatePasswordValidationUI(isLengthValid: Bool, isUppercaseValid: Bool, isNumberValid: Bool, isSpecialCharValid: Bool)
}

final class RegisterViewModel {
    weak var delegate: RegisterViewModelDelegate?
    var coordinator: NavigationCoordinator?

    // MARK: - Public Methods

    func signUp(username: String, email: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        let registerUserRequest = RegisterUserRequest(username: username, email: email, password: password)

        guard Validator.isValidUsername(for: registerUserRequest.username) else {
            delegate?.showInvalidUsernameAlert()
            return
        }

        guard Validator.isValidEmail(for: registerUserRequest.email) else {
            delegate?.showInvalidEmailAlert()
            return
        }

        guard validatePassword(password) else {
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

    // MARK: - Password Validation

    func validatePassword(_ password: String) -> Bool {
        let isLengthValid = PasswordValidator.isPasswordValid(for: password)
        let isUppercaseValid = password.rangeOfCharacter(from: .uppercaseLetters) != nil
        let isNumberValid = password.rangeOfCharacter(from: .decimalDigits) != nil
        let isSpecialCharValid = password.rangeOfCharacter(from: CharacterSet(charactersIn: "!@#$%^&*()")) != nil

        delegate?.updatePasswordValidationUI(
            isLengthValid: isLengthValid,
            isUppercaseValid: isUppercaseValid,
            isNumberValid: isNumberValid,
            isSpecialCharValid: isSpecialCharValid
        )

        return isLengthValid && isUppercaseValid && isNumberValid && isSpecialCharValid
    }
    struct PasswordValidator {
        static func isPasswordValid(for password: String) -> Bool {
            let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
            let passwordRegEx = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[$@$#!%*?&]).{6,32}$"
            let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
            return passwordPredicate.evaluate(with: password)
        }
    }

}
