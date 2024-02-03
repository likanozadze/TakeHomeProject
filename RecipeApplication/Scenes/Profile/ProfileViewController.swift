//
//  ProfileViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class ProfileViewController: UIViewController, RecipeDelegate, FavoriteRecipeCollectionViewDelegate {
    
    private let favoriteRecipeCollectionView = FavoriteRecipeCollectionView()
    var favoriteRecipeModel = FavoriteRecipeModel()
    var selectedRecipes: [Recipe] = []
    var recipeDelegate: RecipeDelegate?
   // private let shoppingListTableView = ShoppingListTableView()
    
    let filterOptions = ["Favorite Recipes", "Shopping List"]
    var selectedSegment = "Favorite Recipes"
    var segmentedControl = UISegmentedControl()

    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        favoriteRecipeCollectionView.favoriteRecipeDelegate = self
        setupSegmentedControl()
        favoriteRecipeCollectionView.reloadData()
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
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
                segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
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
      //  view.addSubview(shoppingListTableView)
    }
    
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            favoriteRecipeCollectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor, constant: 20),
            favoriteRecipeCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            favoriteRecipeCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            favoriteRecipeCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
           // shoppingListTableView.topAnchor.constraint(equalTo: recipeCollectionView.bottomAnchor, constant: 30),
            //shoppingListTableView.trailingAnchor.constraint(equalTo: favoriteRecipeCollectionView.trailingAnchor),
        ])
    }
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        selectedSegment = filterOptions[sender.selectedSegmentIndex]
        
        switch selectedSegment {
        case "Favorite Recipes":
            favoriteRecipeCollectionView.isHidden = false
         //   shoppingListTableView.isHidden = true
        case "Shopping List":
            favoriteRecipeCollectionView.isHidden = true
         //   shoppingListTableView.isHidden = false
        default:
            break
        }
    }

    
    // MARK: - FavoriteRecipeCollectionViewDelegate
    func didTapFavoriteRecipe(recipe: Recipe) {
        favoriteRecipeModel.favoriteNewRecipes(recipe)
        favoriteRecipeCollectionView.reloadData()
        selectedRecipes.append(recipe)
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
      // recipeDelegate?.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)

    }
}


