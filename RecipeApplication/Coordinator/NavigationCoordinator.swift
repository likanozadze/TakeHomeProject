//
//  NavigationCoordinator.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit
import FirebaseAuth
import SwiftUI

protocol OnboardingViewDelegate: AnyObject {
    func didCompleteOnboarding()
}

// MARK: - NavigationCoordinator
class NavigationCoordinator: OnboardingViewDelegate {
    
    // MARK: Properties
    var navigationController: UINavigationController
    
    // MARK: Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    // MARK: Coordinator Methods
    
    func showOnboarding() {
        var onboardingView = OnboardingView(screens: ScreenView.onboardPages)
        onboardingView.delegate = self
        navigationController.pushViewController(UIHostingController(rootView: onboardingView), animated: true)
    }
    
    func didCompleteOnboarding() {
        checkAuthentication()
    }
    
    func start() {
        if UserDefaults.standard.bool(forKey: "hasSeenOnboarding") {
            checkAuthentication()
        } else {
            showOnboarding()
        }
    }
    
    
    // MARK: Authentication Methods
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.coordinator = self
            navigationController.pushViewController(loginViewController, animated: true)
        } else {
            let tabBarController = TabBarController()
            navigationController.pushViewController(tabBarController, animated: true)
        }
    }
    
    func login() {
        let tabBarController =  TabBarController()
        navigationController.pushViewController(tabBarController, animated: true)
    }
    
    func register() {
        let registerViewController = RegisterViewController()
        registerViewController.coordinator = self
        navigationController.pushViewController(registerViewController, animated: true)
    }
    
    public func logout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if error != nil {
            } else {
                self.checkAuthentication()
            }
        }
    }
}
