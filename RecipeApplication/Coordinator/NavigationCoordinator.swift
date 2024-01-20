//
//  NavigationCoordinator.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit

class NavigationCoordinator {
    
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: false)
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
