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
        homeViewController.title = ""
        homeViewController.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 0)
        addLogoAndSearchBarToNavigationBar(of: homeViewController)
        return UINavigationController(rootViewController: homeViewController)
    }
    
    func createShoppingViewNavigation() -> UINavigationController {
        let shoppingListViewController = ShoppingListViewController()
        shoppingListViewController.title = ""
        shoppingListViewController.tabBarItem = UITabBarItem(title: "Shopping list", image: UIImage(systemName: "cart"), tag: 1)
        addLogoToNavigationBar(of: shoppingListViewController)
        return UINavigationController(rootViewController: shoppingListViewController)
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

        let logoContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
        logoContainerView.addSubview(logoImageView)

        let logoBarButton = UIBarButtonItem(customView: logoContainerView)
        viewController.navigationItem.rightBarButtonItem = logoBarButton

        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Recipes"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        searchBar.tintColor = UIColor.secondaryLabel

        viewController.navigationItem.titleView = searchBar
    
    }
    func createTabbar() -> UITabBarController {
        let tabbar = UITabBarController()
        UITabBar.appearance().tintColor = UIColor.accentTextColor
        tabbar.viewControllers = [createHomeViewNavigation(), createShoppingViewNavigation(), createGenerateRecipeViewNavigation(), createProfileViewNavigation()]
        
        return tabbar
    }
    
}
