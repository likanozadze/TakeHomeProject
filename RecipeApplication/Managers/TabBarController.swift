//
//  TabBarController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/10/24.
//

import Foundation
import UIKit
import SwiftUI

class TabBarController: UITabBarController {
    private let navigationCoordinator = NavigationCoordinator(navigationController: UINavigationController())
    var shoppingListViewModel = ShoppingListViewModel.shared
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(named: "AccentColor")
        viewControllers = [
            createHomeViewNavigation(),
            createCategoryViewNavigation(),
            createGenerateRecipeViewNavigation(),
            createOriginalRecipeViewNavigation(),
            createProfilesViewNavigation()]
        
    }
    
    // MARK: Navigation Methods
    
    func createHomeViewNavigation() -> UINavigationController {
        let homeViewController = HomeViewController()
        homeViewController.title = ""
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        
        let navigationController = UINavigationController(rootViewController: homeViewController)
        let navigationCoordinator = NavigationCoordinator(navigationController: navigationController)
        homeViewController.coordinator = navigationCoordinator
        
        return navigationController
    }
    
    
    func createCategoryViewNavigation() -> UINavigationController {
        let categoryViewController = CategoryViewController()
        categoryViewController.title = ""
        categoryViewController.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "list.bullet"), tag: 1)
        return UINavigationController(rootViewController: categoryViewController)
    }
    
    func createGenerateRecipeViewNavigation() -> UINavigationController {
        let generateRecipeViewController = GenerateRecipeViewController()
        generateRecipeViewController.title = ""
        generateRecipeViewController.tabBarItem = UITabBarItem(title: "Generate Recipe", image: UIImage(systemName: "dice"), tag: 2)
        return UINavigationController(rootViewController: generateRecipeViewController)
    }
    
    func createOriginalRecipeViewNavigation() -> UINavigationController {
        let originalRecipeViewController = OriginalRecipeViewController()
        originalRecipeViewController.title = ""
        originalRecipeViewController.tabBarItem = UITabBarItem(title: "Your recipe", image: UIImage(systemName: "plus.circle"), tag: 3)
        let navigationController = UINavigationController(rootViewController: originalRecipeViewController)
        
        return navigationController
    }
    
    func createProfilesViewNavigation() -> UINavigationController {
        let profileHostingController = UIHostingController(rootView: ProfilePage()
            .environmentObject(ShoppingListViewModel.shared)
            .environmentObject(AuthService.shared))
        profileHostingController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        let navigationController = UINavigationController(rootViewController: profileHostingController)
        return navigationController
        
    }
    
}
