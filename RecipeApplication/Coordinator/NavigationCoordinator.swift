//
//  NavigationCoordinator.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit
import FirebaseAuth

class NavigationCoordinator {
    
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        checkAuthentication()
    }
    
    public func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            let loginViewController = LoginViewController()
            loginViewController.coordinator = self
            navigationController.pushViewController(loginViewController, animated: true)
        } else {
            let tabBarController = createTabbar()
            navigationController.pushViewController(tabBarController, animated: true)
        }
    }
    
    func login() {
        let tabBarController = createTabbar()
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
    
    func createHomeViewNavigation() -> UINavigationController {
        let homeViewController = HomeViewController()
        homeViewController.title = "Home"
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        return UINavigationController(rootViewController: homeViewController)
    }
    
    func createShoppingViewNavigation() -> UINavigationController {
        let shoppingListViewController = ShoppingListViewController()
        shoppingListViewController.title = "Shopping list"
        shoppingListViewController.tabBarItem = UITabBarItem(title: "Shopping list", image: UIImage(systemName: "cart"), tag: 1)
        
        return UINavigationController(rootViewController: shoppingListViewController)
    }
    
    func createGenerateRecipeViewNavigation() -> UINavigationController {
        let generateRecipeViewController = GenerateRecipeViewController()
        generateRecipeViewController.title = "Generate Recipe"
        generateRecipeViewController.tabBarItem = UITabBarItem(title: "Generate Recipe", image: UIImage(systemName: "list.clipboard"), tag: 2)
        
        return UINavigationController(rootViewController: generateRecipeViewController)
    }
    
    func createProfileViewNavigation() -> UINavigationController {
        let profileViewController = ProfileViewController()
        profileViewController.title = "Account"
        profileViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 3)
        
        return UINavigationController(rootViewController: profileViewController)
    }
    
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = UIColor.accentTextColor
        tabbar.viewControllers = [createHomeViewNavigation(), createShoppingViewNavigation(), createGenerateRecipeViewNavigation(), createProfileViewNavigation()]
        
        return tabbar
    }
}
