//
//  ProfileViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//


import UIKit

final class ProfileViewController: UIViewController, FavoriteRecipeCollectionViewDelegate, RecipeDelegate {
    
   private let favoriteRecipeCollectionView = FavoriteRecipeCollectionView()
    var favoriteRecipeModel = FavoriteRecipeModel()
    var selectedRecipes: [Recipe] = []
    var recipeDelegate: RecipeDelegate?
  //  private let shoppingListTableView = ShoppingListTableView()

    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        favoriteRecipeCollectionView.favoriteRecipeDelegate = self
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
        view.addSubview(favoriteRecipeCollectionView)
    }
    
    
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            favoriteRecipeCollectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favoriteRecipeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteRecipeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteRecipeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
//        NSLayoutConstraint.activate([
//            shoppingListTableView.topAnchor.constraint(equalTo: favoriteRecipeCollectionView.bottomAnchor, constant: 5),
//            //shoppingListTableView.trailingAnchor.constraint(equalTo: favoriteRecipeCollectionView.trailingAnchor),
//        ])
    }

    
    // MARK: - FavoriteRecipeCollectionViewDelegate
    func didTapFavoriteRecipe(recipe: Recipe) {
        favoriteRecipeModel.favoriteNewRecipes(recipe)
        favoriteRecipeCollectionView.reloadData()
        selectedRecipes.append(recipe)
    }
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        self.selectedRecipes = selectedRecipes
        favoriteRecipeCollectionView.reloadData()
    }
    func favoriteRecipeCollectionView(_ collectionView: FavoriteRecipeCollectionView, didTapFavoriteRecipe recipe: Recipe) {
        didTapFavoriteRecipe(recipe: recipe)
    }
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
    }
}

