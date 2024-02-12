//
//  CategoryRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import UIKit
import SwiftUI

// MARK: - RecipeDelegate
final class CategoryRecipeViewController: UIViewController, RecipeItemCollectionViewCellDelegate {
    
    // MARK: Properties
    
    var categoryViewModel = CategoryViewModel()
    var selectedCategory: String?
    var categoryRecipeCollectionView = CategoryRecipeCollectionView()
    private var recipe: [Recipe] = []
    private var selectedRecipes: [Recipe] = []
    var coordinator: NavigationCoordinator?
    weak var delegate: RecipeItemCollectionViewCellDelegate?
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        coordinator = NavigationCoordinator(navigationController: navigationController!)
                coordinator?.delegate = self
        categoryRecipeCollectionView.delegate = self
        categoryRecipeCollectionView.dataSource = self
        
        if let selectedCategory = selectedCategory {
            categoryViewModel.delegate = self
            categoryViewModel.fetchRecipesByTag(selectedCategory)
           
        }
    }
    
    // MARK: - UI Setup
    
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
    }
    
    private func addMainSubviews() {
        view.addSubview(categoryRecipeCollectionView)
    }
    
    func setupConstraints() {
        categoryRecipeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            categoryRecipeCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            categoryRecipeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categoryRecipeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            categoryRecipeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
    }
}

    // MARK: - CategoryListViewModelDelegate

    extension CategoryRecipeViewController: CategoryListViewModelDelegate {
    func categoriesFetched(_ recipes: [Recipe]) {
        self.recipe = recipes
        DispatchQueue.main.async {
            self.categoryRecipeCollectionView.reloadData()
        }
    }

    func categoryFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    
    }
}


// MARK: - UICollectionViewDataSource

extension CategoryRecipeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(recipe.count)")
        return recipe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.isUserInteractionEnabled = true
         cell.delegate = self
        cell.configure(with: recipe[indexPath.row])
        return cell
    }
}


// MARK: - CollectionView FlowLayoutDelegate
extension CategoryRecipeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 340, height: 240)
        
    }
}

extension CategoryRecipeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recipe = categoryViewModel.recipe(at: indexPath) {
            coordinator?.didSelectRecipe(recipe: recipe)
        }
    }
}

// MARK: - NavigationCoordinatorDelegate
extension CategoryRecipeViewController: NavigationCoordinatorDelegate {
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        coordinator?.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
    }
    
    func didSelectRecipe(recipe: Recipe) {
        coordinator?.didSelectRecipe(recipe: recipe)
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        coordinator?.didSelectRecipe(on: cell)
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        coordinator?.didTapFavoriteButton(on: cell)
    }
}
