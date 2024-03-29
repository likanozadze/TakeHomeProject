
//
//  NavigationCoordinator.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit
import FirebaseAuth
import SwiftUI


enum AppState {
    case onboarding
    case authenticated(user: User)
    case unauthenticated
}

protocol OnboardingViewDelegate: AnyObject {
    func didCompleteOnboarding()
}

protocol NavigationCoordinatorDelegate: AnyObject {
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe])
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell)
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell)
    func didSelectRecipe(recipe: Recipe)
}

// MARK: - NavigationCoordinator

class NavigationCoordinator: OnboardingViewDelegate, NavigationCoordinatorDelegate {
    
    // MARK: Properties
    var navigationController: UINavigationController
    weak var delegate: NavigationCoordinatorDelegate?
    private let recipeCollectionView = RecipeCollectionView()
    private var recipe: [Recipe] = []
    private var selectedRecipes: [Recipe] = []
    private let viewModel = HomeViewModel()
    private let categoryViewModel = CategoryViewModel()
    private var categoryCollectionView = CategoryCollectionView()
    private var favoriteRecipeCollectionView = FavoriteRecipeCollectionView()
    private var favoriteRecipes: [Recipe] = []
    
    private var state: AppState = .onboarding {
        didSet {
            transitionTo(state)
        }
    }
    
    // MARK: Initialization
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: Coordinator Methods

    func start() {
        let hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
        state = hasSeenOnboarding ? .authenticated(user: User(id: "", username: "", email: "", recipes: nil, likedRecipes: nil)) : .onboarding
    }

    func checkAuthentication() {
        if Auth.auth().currentUser == nil {
            presentLoginViewController()
        } else {
            presentTabBarControllerOnMainThread()
        }
    }
        
    // MARK: State Management Methods
        private func transitionTo(_ state: AppState) {
                switch state {
                case .onboarding:
                    showOnboarding()
                case .authenticated:
                    presentTabBarControllerOnMainThread()
                case .unauthenticated:
                    presentLoginViewController()
        }
    }
    

    // MARK: Authentication Methods
    func showOnboarding() {
        var onboardingView = OnboardingView(screens: ScreenView.onboardPages)
        onboardingView.delegate = self
        navigationController.pushViewController(UIHostingController(rootView: onboardingView), animated: true)
    }
    
    func didCompleteOnboarding() {
        checkAuthentication()
    }
    
    func presentLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        navigationController.pushViewController(loginViewController, animated: true)
    }
    
    private func presentTabBarControllerOnMainThread() {
        DispatchQueue.main.async {
            let tabBarController = TabBarController()
            self.navigationController.pushViewController(tabBarController, animated: true)
        }
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
    
    
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        let profileVC = FavoritesViewController()
        profileVC.selectedRecipes = selectedRecipes
        navigationController.pushViewController(profileVC, animated: true)
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let indexPath = recipeCollectionView.indexPath(for: cell),
           let recipe = viewModel.recipe(at: indexPath) {
            let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: recipe.extendedIngredients?[indexPath.row])
            let detailWrapper = RecipeDetailViewWrapper(viewModel: detailViewModel)
            
            let hostingController = UIHostingController(rootView: detailWrapper)
            navigationController.pushViewController(hostingController, animated: true)
        }
    }
    
    func didSelectCategory(on cell: CategoryCollectionViewCell) {
        if let indexPath = categoryCollectionView.indexPath(for: cell) {
            let selectedTag = categoryData[indexPath.row].title.lowercased()
            
            
            let categoryRecipeViewController = CategoryRecipeViewController()
            
            categoryRecipeViewController.selectedCategory = selectedTag
            categoryRecipeViewController.categoryViewModel.fetchRecipesByTag(selectedTag)
            categoryRecipeViewController.categoryViewModel.recipes = recipe
            navigationController.pushViewController(categoryRecipeViewController, animated: true)
        }
    }
    
    func didSelectRecipe(recipe: Recipe) {
        let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: nil)
        let detailWrapper = RecipeDetailView(viewModel: detailViewModel)
        
        let hostingController = UIHostingController(rootView: detailWrapper)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = recipeCollectionView.indexPath(for: cell) else { return }
        let recipe = self.recipe[indexPath.item]
        
        if cell.favoriteButton.isSelected {
            PersistenceManager.updateWith(favorite: recipe, actionType: .add) { error in
                if let error = error {
                    print("Error favoriting recipe: \(error.rawValue)")
                } else {
                    self.selectedRecipes.append(recipe)
                }
            }
        } else {
            PersistenceManager.updateWith(favorite: recipe, actionType: .remove) { error in
                if let error = error {
                    print("Error unfavoriting recipe: \(error.rawValue)")
                } else {
                    self.selectedRecipes = self.selectedRecipes.filter { $0.id != recipe.id }
                }
            }
        }
        
    }
    func didTapUnfavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = favoriteRecipeCollectionView.indexPath(for: cell) else { return }
        let recipe = self.favoriteRecipes[indexPath.item]

        PersistenceManager.updateWith(favorite: recipe, actionType: .remove) { error in
            if let error = error {
                print("Error unfavoriting recipe: \(error.rawValue)")
            } else {
                self.selectedRecipes = self.selectedRecipes.filter { $0.id != recipe.id }
                self.favoriteRecipes = self.favoriteRecipes.filter { $0.id != recipe.id }
                self.favoriteRecipeCollectionView.reloadData()
            }
        }
    }

}
