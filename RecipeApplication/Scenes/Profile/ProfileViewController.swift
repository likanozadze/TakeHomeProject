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
    // private let shoppingListTableView = ShoppingListTableView()
    
    private let filterOptions = ["Favorite Recipes", "Shopping List"]
    private var selectedSegment = "Favorite Recipes"
    private var segmentedControl = UISegmentedControl()
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
        favoriteRecipeCollectionView.favoriteRecipeDelegate = self
        setupSegmentedControl()
        favoriteRecipeCollectionView.reloadData()
    }
    
    private func setupSegmentedControl() {
        segmentedControl = UISegmentedControl(items: filterOptions)
        segmentedControl.selectedSegmentTintColor = UIColor(red: 134/255, green: 191/255, blue: 62/255, alpha: 1.0)
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white
        ]
        segmentedControl.setTitleTextAttributes(attributes, for: .selected)
        segmentedControl.selectedSegmentIndex = filterOptions.firstIndex(of: selectedSegment) ?? 0
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
        
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            segmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
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
        //  view.addSubview(IngredientCellView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            favoriteRecipeCollectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 40),
            favoriteRecipeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteRecipeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteRecipeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            // IngredientCellView.topAnchor.constraint(equalTo: recipeCollectionView.bottomAnchor, constant: 30),
            //IngredientCellView.trailingAnchor.constraint(equalTo: favoriteRecipeCollectionView.trailingAnchor),
        ])
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedSegment = filterOptions[sender.selectedSegmentIndex]
        
        switch selectedSegment {
        case "Favorite Recipes":
            favoriteRecipeCollectionView.isHidden = false
            //   IngredientCellView.isHidden = true
        case "Shopping List":
            favoriteRecipeCollectionView.isHidden = true
            //   IngredientCellView.isHidden = false
        default:
            break
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
    }
