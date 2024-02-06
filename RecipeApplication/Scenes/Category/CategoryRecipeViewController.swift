//
//  CategoryRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import UIKit
import SwiftUI

// MARK: - RecipeDelegate

final class CategoryRecipeViewController: UIViewController, UICollectionViewDelegate, RecipeItemCollectionViewCellDelegate, CategoryListViewModelDelegate {

    // MARK: Properties

    weak var recipeDelegate: RecipeDelegate?
    var categoryViewModel = CategoryViewModel()
    var selectedCategory: String?
    var categoryRecipeCollectionView = CategoryRecipeCollectionView()

    private var recipe: [Recipe] = []
    private var selectedRecipes: [Recipe] = []
    var favoriteRecipeModel = FavoriteRecipeModel()

    // MARK: - ViewLifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        categoryRecipeCollectionView.register(RecipeItemCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeItemCell")

        if let selectedCategory = selectedCategory {
            categoryViewModel.delegate = self
            categoryViewModel.fetchRecipesByTag(selectedCategory)
            categoryRecipeCollectionView.delegate = self
            categoryRecipeCollectionView.dataSource = self
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
        view.backgroundColor = UIColor.backgroundColor
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

// MARK: - UICollectionViewDataSource

extension CategoryRecipeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(recipe.count)")
        return recipe.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            print("Error: Unable to dequeue RecipeItemCollectionViewCell.")
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configure(with: recipe[indexPath.row])
        return cell
    }

    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = categoryRecipeCollectionView.indexPath(for: cell) else { return }
        let recipe = self.recipe[indexPath.item]
        
        if cell.favoriteButton.isSelected {
            favoriteRecipeModel.favoriteNewRecipes(recipe)
            selectedRecipes.append(recipe)
        } else {
            favoriteRecipeModel.deleteFavoriteRecipe(recipe)
            selectedRecipes = selectedRecipes.filter { $0.id != recipe.id }
        }
        
        categoryRecipeCollectionView.reloadItems(at: [indexPath])
        recipeDelegate?.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
        
        if let delegate = recipeDelegate {
            print("Recipes selected in HomeViewController: \(selectedRecipes)")
            delegate.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
        } else {
            print("Recipe delegate is nil.")
            
        }
    }
    
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let selectedRecipe = cell.recipe {
            print("Selected Recipe: \(selectedRecipe.title)")
            let detailViewModel = RecipeDetailViewModel(recipe: selectedRecipe, selectedIngredient: selectedRecipe.extendedIngredients?.first)
            let detailWrapper = RecipeDetailViewWrapper(viewModel: detailViewModel)
            
            let hostingController = UIHostingController(rootView: detailWrapper)
            navigationController?.pushViewController(hostingController, animated: true)
        }
    
 }
   
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