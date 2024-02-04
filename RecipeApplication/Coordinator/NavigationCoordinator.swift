//
//  NavigationCoordinator.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit
import FirebaseAuth

// MARK: - NavigationCoordinator
class NavigationCoordinator {
    
    // MARK: Properties
    var navigationController: UINavigationController
    
    // MARK: Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    // MARK: Coordinator Methods
    
    func start() {
        checkAuthentication()
    }
    
    // MARK: Authentication Methods
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
    
    // MARK: Tab Bar Creation
    private func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = UIColor.accentTextColor
        tabbar.viewControllers = [
            createHomeViewNavigation(),
            createCategoryViewNavigation(),
            createGenerateRecipeViewNavigation(),
            createProfileViewNavigation(),
        ]
        
        return tabbar
    }
    
    // MARK: Navigation Bar Customization
    private func addLogoToNavigationBar(of viewController: UIViewController) {
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
    
    private func addLogoAndSearchBarToNavigationBar(of viewController: UIViewController) {
        let logoImageView = UIImageView()
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFill
        logoImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        logoImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        
    }
}
