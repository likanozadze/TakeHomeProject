//
//  TabBarController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/10/24.
//

import Foundation
import UIKit


class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = UIColor(named: "AccentColor")
        viewControllers = [
            createHomeViewNavigation(),
            createCategoryViewNavigation(),
            createGenerateRecipeViewNavigation(),
            createProfileViewNavigation()]
        
        
        // MARK: Navigation Methods
        
        func createHomeViewNavigation() -> UINavigationController {
            let homeViewController = HomeViewController()
            homeViewController.title = ""
            homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
            addLogoToNavigationBar(of: homeViewController)
            return UINavigationController(rootViewController: homeViewController)
        }
        
        func createCategoryViewNavigation() -> UINavigationController {
            let categoryViewController = CategoryViewController()
            categoryViewController.title = ""
            categoryViewController.tabBarItem = UITabBarItem(title: "Category", image: UIImage(systemName: "list.bullet"), tag: 1)
            addLogoToNavigationBar(of: categoryViewController)
            return UINavigationController(rootViewController: categoryViewController)
        }
        
        func createGenerateRecipeViewNavigation() -> UINavigationController {
            let generateRecipeViewController = GenerateRecipeViewController()
            generateRecipeViewController.title = ""
            generateRecipeViewController.tabBarItem = UITabBarItem(title: "Generate Recipe", image: UIImage(systemName: "list.clipboard"), tag: 2)
            addLogoToNavigationBar(of: generateRecipeViewController)
            return UINavigationController(rootViewController: generateRecipeViewController)
        }
        
        func createProfileViewNavigation() -> UINavigationController {
            let profileViewController = ProfileViewController()
            profileViewController.title = ""
            profileViewController.tabBarItem = UITabBarItem(title: "Account", image: UIImage(systemName: "person.crop.circle"), tag: 3)
            addLogoToNavigationBar(of: profileViewController)
            return UINavigationController(rootViewController: profileViewController)
        }
        
        
        
        
        // MARK: Navigation Bar Customization
        func addLogoToNavigationBar(of viewController: UIViewController) {
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "logo")
            logoImageView.contentMode = .scaleAspectFill
            logoImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let logoContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
            logoContainerView.addSubview(logoImageView)
            
            let logoBarButton = UIBarButtonItem(customView: logoContainerView)
            viewController.navigationItem.rightBarButtonItem = logoBarButton
        }
        
        func addLogoAndSearchBarToNavigationBar(of viewController: UIViewController) {
            let logoImageView = UIImageView()
            logoImageView.image = UIImage(named: "logo")
            logoImageView.contentMode = .scaleAspectFill
            logoImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
            logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
            logoImageView.translatesAutoresizingMaskIntoConstraints = false
            
        }
    }
}
