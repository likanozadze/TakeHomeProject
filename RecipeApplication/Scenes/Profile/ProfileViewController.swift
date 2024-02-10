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
    var selectedRecipes: [Recipe] = []
    var recipeDelegate: RecipeDelegate?
    private let shoppingListTableView = ShoppingListTableView()
    var shoppingList: [ExtendedIngredient] = []
    var segmentedControl: UISegmentedControl!
    var containerView: UIView!
    var shoppingListStore = ShoppingListStore()
    private var favoriteRecipes: [Recipe] = []
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retrieveFavorites()
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
    
    private func retrieveFavorites() {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favoriteRecipes):
                print("Retrieved favorite recipes: \(favoriteRecipes)")
                self.favoriteRecipeCollectionView.setFavoriteRecipes(favoriteRecipes)
            case .failure(let error):
                print("Error retrieving favorites: \(error.rawValue)")
            }
        }
    }
}


    // MARK: - FavoriteRecipeCollectionViewDelegate
//extension ProfileViewController: FavoriteRecipeCollectionViewDelegate {
//    func didTapFavoriteRecipe(recipe: Recipe) {
//        PersistenceManager.retrieveFavorites { [weak self] result in
//            guard let self = self else { return }
//            switch result {
//            case .success(let favoriteRecipes):
//                let isRecipeFavorited = favoriteRecipes.contains(where: { $0.id == recipe.id })
//                if isRecipeFavorited {
//                    print("Recipe already favorited")
//                } else {
//                    PersistenceManager.updateWith(favorite: recipe, actionType: .add) { error in
//                        if let error = error {
//                            print("Error favoriting recipe: \(error.rawValue)")
//                        } else {
//                            print("Recipe favorited successfully.")
//                            self.selectedRecipes.append(recipe)
//                            DispatchQueue.main.async {
//                                self.favoriteRecipeCollectionView.reloadData()
//                            }
//                        }
//                    }
//                }
//                self.navigateToRecipeDetailView(with: recipe)
//            case .failure(let error):
//                print("Error retrieving favorites: \(error.rawValue)")
//            }
//        }
//    }

extension ProfileViewController: FavoriteRecipeCollectionViewDelegate {
    func didTapFavoriteRecipe(recipe: Recipe) {
        PersistenceManager.retrieveFavorites { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let favoriteRecipes):
                let isRecipeFavorited = favoriteRecipes.contains(where: { $0.id == recipe.id })
                if isRecipeFavorited {
                    PersistenceManager.updateWith(favorite: recipe, actionType: .remove) { error in
                        if let error = error {
                            print("Error unfavoriting recipe: \(error.rawValue)")
                        } else {
                            print("Recipe unfavorited successfully.")
                            if let index = self.favoriteRecipes.firstIndex(where: { $0.id == recipe.id }) {
                                self.favoriteRecipes.remove(at: index)
                                DispatchQueue.main.async {
                                    self.favoriteRecipeCollectionView.reloadData()
                                }
                            }
                        }
                    }
                }
                self.navigateToRecipeDetailView(with: recipe)
            case .failure(let error):
                print("Error retrieving favorites: \(error.rawValue)")
            }
        }
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
        favoriteRecipeCollectionView.reloadData()
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let indexPath = favoriteRecipeCollectionView.indexPath(for: cell) {
            PersistenceManager.retrieveFavorites { result in
                switch result {
                case .success(let favoriteRecipes):
                    guard indexPath.row < favoriteRecipes.count else {
                        return
                    }
                    let recipe = favoriteRecipes[indexPath.row]
                    self.navigateToRecipeDetailView(with: recipe)
                case .failure(let error):
                    print("Error retrieving favorites: \(error.rawValue)")
                }
            }
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

