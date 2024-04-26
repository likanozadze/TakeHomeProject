//
//  ProfileViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit
import SwiftUI

final class FavoritesViewController: UIViewController, FavoriteRecipeCollectionViewDelegate {
    
    // MARK: - Properties
    
    private let favoriteRecipeCollectionView = FavoriteRecipeCollectionView()
    let emptyStateViewController = EmptyStateViewController(
        title: "Save recipes you love", description: "Collect the recipes that inspire you. Tap the heart to save them here", animationName: "Animation - 1709293040117")
    var selectedRecipes: [Recipe] = []
    private var favoriteRecipes: [Recipe] = []
    var coordinator: NavigationCoordinator?

    var shoppingListViewModel = ShoppingListViewModel()
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [favoriteRecipeCollectionView])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        updateEmptyStateVisibility()
    }
    private func updateEmptyStateVisibility() {
        if favoriteRecipes.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveFavorites()
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
        favoriteRecipeCollectionView.favoriteRecipeDelegate = self
        favoriteRecipeCollectionView.reloadData()
    }
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
 
    private func addSubviewsToView() {
        addMainSubviews()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
 
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
    }

    private func showEmptyState() {
        addChild(emptyStateViewController)
        emptyStateViewController.view.frame = view.bounds
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.didMove(toParent: self)
    }

    private func hideEmptyState() {
        if children.contains(emptyStateViewController) {
            emptyStateViewController.willMove(toParent: nil)
            emptyStateViewController.view.removeFromSuperview()
            emptyStateViewController.removeFromParent()
        }
    }
    
    private func retrieveFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favoriteRecipes):
                self.favoriteRecipes = favoriteRecipes
                self.favoriteRecipeCollectionView.setFavoriteRecipes(favoriteRecipes)
                self.updateEmptyStateVisibility()
            case .failure(_):
                break
            }
        }
    }
}

// MARK: - NavigationCoordinatorDelegate
extension FavoritesViewController: NavigationCoordinatorDelegate {
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        cell.favoriteButton.isSelected = !cell.favoriteButton.isSelected
        if cell.favoriteButton.isSelected {
            coordinator?.didTapFavoriteButton(on: cell)
        } else {
    
        }
        
        func recipesUpdated() {
            updateEmptyStateVisibility()
        }
    }
  
    func didSelectRecipe(recipe: Recipe) {
        coordinator?.didSelectRecipe(recipe: recipe)
    }
    
   
    func didTapFavoriteRecipe(recipe: Recipe) {
        self.navigateToRecipeDetailView(with: recipe)
    }
    
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        self.selectedRecipes = selectedRecipes
        print("ProfileViewController - Selected recipes: \(selectedRecipes)")
        favoriteRecipeCollectionView.reloadData()
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        coordinator?.didSelectRecipe(on: cell)
    }
    
    private func navigateToRecipeDetailView(with recipe: Recipe) {
        print("Recipe selected in ProfileViewController: \(recipe.title)")
        
        let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: nil)
        let detailWrapper = RecipeDetailView(viewModel: detailViewModel)
            .environmentObject(shoppingListViewModel)
        let hostingController = UIHostingController(rootView: detailWrapper)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

