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

class NavigationCoordinator: ObservableObject, OnboardingViewDelegate, NavigationCoordinatorDelegate {
    
    // MARK: Properties
    var navigationController: UINavigationController
    weak var delegate: NavigationCoordinatorDelegate?
    private let recipeCollectionView = RecipeCollectionView()
    private var recipe: [Recipe] = []
    private var selectedRecipes: [Recipe] = []
    private let viewModel = HomeViewModel()
    private let categoryViewModel = CategoryViewModel()
    private var categoryCollectionView = CategoryCollectionView()
    var shoppingListViewModel = ShoppingListViewModel.shared
    
    
    public var state: AppState = .onboarding {
        didSet {
            print("State changed to \(state)")
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
        let didLogout = UserDefaults.standard.bool(forKey: "didLogout")
        print("hasSeenOnboarding: \(hasSeenOnboarding), didLogout: \(didLogout)")
        
        if didLogout {
            UserDefaults.standard.set(false, forKey: "didLogout")
            state = .unauthenticated
        } else if Auth.auth().currentUser != nil {
            state = .authenticated(user: User(id: "", username: "", email: "", recipes: nil, likedRecipes: nil, shoppingListString: nil))
        } else if !hasSeenOnboarding {
            state = .onboarding
        } else {
            state = .unauthenticated
        }
        
        Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            guard let self = self else { return }
            if user == nil {
                if didLogout && hasSeenOnboarding {
                    self.state = .unauthenticated
                } else {
                    self.state = hasSeenOnboarding ? .unauthenticated : .onboarding
                }
            }
        }
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
        UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
        checkAuthentication()
    }
    
    func presentLoginViewController() {
        print("Presenting LoginViewController")
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
                .environmentObject(shoppingListViewModel)
            
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
            .environmentObject(shoppingListViewModel)
        let hostingController = UIHostingController(rootView: detailWrapper)
        navigationController.pushViewController(hostingController, animated: true)
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = recipeCollectionView.indexPath(for: cell) else { return }
        let recipe = self.recipe[indexPath.item]
        
        PersistenceManager.toggleFavorite(recipe: recipe) { result in
            switch result {
            case .success(let isFavorited):
                if isFavorited {
                    self.selectedRecipes.append(recipe)
                } else {
                    self.selectedRecipes.removeAll(where: {$0.id == recipe.id})
                }
                cell.favoriteButton.isSelected = isFavorited
            case .failure(let error):
                print("Failed to toggle favorite: \(error.localizedDescription)")
                
            }
        }
    }
}
