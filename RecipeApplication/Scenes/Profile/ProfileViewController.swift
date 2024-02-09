//
//  ProfileViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit
import SwiftUI

final class ProfileViewController: UIViewController {
    
    // MARK: - Properties
    
    private let favoriteRecipeCollectionView = FavoriteRecipeCollectionView()
    private var favoriteRecipeModel = FavoriteRecipeModel()
    var selectedRecipes: [Recipe] = []
    var recipeDelegate: RecipeDelegate?
    private let shoppingListTableView = ShoppingListTableView()
    var shoppingList: [ExtendedIngredient] = []
    var segmentedControl: UISegmentedControl!
    var containerView: UIView!
    var shoppingListStore = ShoppingListStore()
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        setupSegmentedControl()
        addSubviewsToView()
        setupConstraints()
      
        favoriteRecipeCollectionView.favoriteRecipeDelegate = self

        favoriteRecipeCollectionView.reloadData()
        shoppingListTableView.reloadData()
    }
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: ["Favorite Recipes", "Shopping List"])
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(segmentValueChanged(_:)), for: .valueChanged)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    // MARK: - Private Methods
  
    
    private func addSubviewsToView() {
        containerView.addSubview(favoriteRecipeCollectionView)
        containerView.addSubview(shoppingListTableView)
        
    }

    
    private func setupConstraints() {
        favoriteRecipeCollectionView.translatesAutoresizingMaskIntoConstraints = false
        shoppingListTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            favoriteRecipeCollectionView.topAnchor.constraint(equalTo: containerView.topAnchor),
            favoriteRecipeCollectionView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            favoriteRecipeCollectionView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            favoriteRecipeCollectionView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            
            shoppingListTableView.topAnchor.constraint(equalTo: containerView.topAnchor),
            shoppingListTableView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            shoppingListTableView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            shoppingListTableView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        favoriteRecipeCollectionView.isHidden = false
        shoppingListTableView.isHidden = true
    }
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
            
            if sender.selectedSegmentIndex == 0 {
                favoriteRecipeCollectionView.isHidden = false
                shoppingListTableView.isHidden = true
            } else {
                favoriteRecipeCollectionView.isHidden = true
                shoppingListTableView.isHidden = false
                shoppingListTableView.reloadData()
            }
        }
    }

    // MARK: - FavoriteRecipeCollectionViewDelegate
extension ProfileViewController: FavoriteRecipeCollectionViewDelegate {
    
    func didTapFavoriteRecipe(recipe: Recipe) {
        favoriteRecipeModel.favoriteNewRecipes(recipe)
        selectedRecipes.append(recipe)
        favoriteRecipeCollectionView.reloadData()
        navigateToRecipeDetailView(with: recipe)
    }
    
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        self.selectedRecipes = selectedRecipes
        print("ProfileViewController - Selected recipes: \(selectedRecipes)")
        favoriteRecipeCollectionView.reloadData()
    }
    
    func favoriteRecipeCollectionView(_ collectionView: FavoriteRecipeCollectionView, didTapFavoriteRecipe recipe: Recipe) {
        didTapFavoriteRecipe(recipe: recipe)
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let indexPath = favoriteRecipeCollectionView.indexPath(for: cell) {
            let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
            navigateToRecipeDetailView(with: recipe)
        }
    }
    
    private func navigateToRecipeDetailView(with recipe: Recipe) {
        print("Recipe selected in ProfileViewController: \(recipe.title)")
        
        let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: nil)
        let detailWrapper = RecipeDetailView(viewModel: detailViewModel)
        let hostingController = UIHostingController(rootView: detailWrapper)
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    private func updateShoppingList() {
        print("Current shopping list:")
        for item in shoppingList {
            print("\(item.name) - \(item.amount) \(item.unit)")
        }
    }
}
