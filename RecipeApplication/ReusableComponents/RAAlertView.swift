//
//  RAAlertView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

enum RAError: String, Error {
    case unableToFavorite = "There was an error favoriting this recipe. Please try again."
    case alreadyInFavorites = "You've already favorited this recipe. You must REALLY like it."
}


class RAAlertView {
    
    // MARK: - Generic Alert
    
    private static func showGenericAlert(on viewController: UIViewController, title: String, message: String?) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            viewController.present(alert, animated: true)
        }
    }
}

// MARK: - Validation Alerts
extension RAAlertView {
    
    public static func showInvalidEmailAlert(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Invalid Email", message: "Please enter a valid email.")
    }
    
    public static func showInvalidPasswordAlert(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Invalid Password", message: "Please enter a valid password.")
    }
    
    public static func showInvalidUsernameAlert(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Invalid Username", message: "Please enter a valid Username.")
    }
}

// MARK: - Registration Error
extension RAAlertView {
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with error: Error) {
        self.showGenericAlert(on: vc, title: "Registration Error", message: "\(error.localizedDescription)")
    }
    
    public static func showRegistrationErrorAlert(on vc: UIViewController, with customMessage: String) {
        self.showGenericAlert(on: vc, title: "Registration Error", message: customMessage)
    }
    public static func showSuccessRegistrationAlert(on vc: UIViewController) {
            self.showGenericAlert(on: vc, title: "Success", message: "Registration successful!")
        }
}

// MARK: - Log In Errors
extension RAAlertView {
    
    public static func showSignInErrorAlert(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Unknown Error Signing In", message: nil)
    }
    
    public static func showSignInErrorAlert(on vc: UIViewController, with error: String) {
        self.showGenericAlert(on: vc, title: "Error Signing In", message: "\(error)")
    }
}


// MARK: - Logout Errors
extension RAAlertView {
    
    public static func showLogoutError(on vc: UIViewController, with error: Error) {
        self.showGenericAlert(on: vc, title: "Log Out Error", message: "\(error.localizedDescription)")
    }
}

// MARK: - Fetching User Errors
extension RAAlertView {
    
    public static func showFetchingUserError(on vc: UIViewController, with error: Error) {
        self.showGenericAlert(on: vc, title: "Error Fetching User", message: "\(error.localizedDescription)")
    }
    
    public static func showUnknownFetchingUserError(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Unknown Error Fetching User", message: nil)
    }
}
// MARK: - Recipe Errors
extension RAAlertView {
    
    public static func showFavoriteRecipeError(on vc: UIViewController, with error: RAError) {
        self.showGenericAlert(on: vc, title: "Error Favoriting Recipe", message: error.rawValue)
    }
    
    public static func showAlreadyInFavoritesAlert(on vc: UIViewController, with error: RAError) {
        self.showGenericAlert(on: vc, title: "Recipe Already Favorited", message: error.rawValue)
    }
}
// MARK: - Favorite Recipe Alerts
extension RAAlertView {
    
    public static func showAddToFavoritesSuccessAlert(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Success", message: "Recipe added to favorites!")
    }
}
