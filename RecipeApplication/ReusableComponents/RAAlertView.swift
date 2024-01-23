//
//  RAAlertView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

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


// MARK: - Forgot Password
extension RAAlertView {
    
    public static func showPasswordResetSent(on vc: UIViewController) {
        self.showGenericAlert(on: vc, title: "Password Reset Sent", message: nil)
    }
    
    public static func showErrorSendingPasswordReset(on vc: UIViewController, with error: String) {
        self.showGenericAlert(on: vc, title: "Error Sending Password Reset", message: "\(error)")
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
