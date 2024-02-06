//
//  CategoryRecipeCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import UIKit


// MARK: - RecipeCollectionView
final class CategoryRecipeCollectionView: UICollectionView, UICollectionViewDelegate {
  
    
    // MARK: Properties
    var selectedRecipes: [Recipe] = []
    var favoriteRecipeModel = FavoriteRecipeModel()
    weak var recipeCollectionViewDelegate: RecipeCollectionViewDelegate?
    var recipe: [Recipe] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let customLayout = UICollectionViewFlowLayout()
        customLayout.scrollDirection = .vertical
        super.init(frame: frame, collectionViewLayout: customLayout)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        dataSource = self
        delegate = self
        setupCollectionView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Collection View
    
    private func setupCollectionView() {
        self.register(RecipeItemCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeItemCell")
    }
}
    
    // MARK: - UICollectionViewDataSource
    extension CategoryRecipeCollectionView: UICollectionViewDataSource {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return recipe.count
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let recipe = self.recipe[indexPath.row]
            cell.configure(with: recipe)
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
            recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
        }
    }

