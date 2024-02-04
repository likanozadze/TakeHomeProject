//
//  RecipeCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/3/24.
//

import UIKit

// MARK: - RecipeCollectionViewDelegate

protocol RecipeCollectionViewDelegate: AnyObject {
    func didTapFavoriteRecipe(recipe: Recipe)
}

// MARK: - RecipeCollectionView
final class RecipeCollectionView: UICollectionView {
    
// MARK: Properties
    var selectedRecipes: [Recipe] = []
    var favoriteRecipeModel = FavoriteRecipeModel()
    weak var recipeCollectionViewDelegate: RecipeCollectionViewDelegate?
    private var recipe: [Recipe] = []
    
    // MARK: - Initialization
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 16
        
        super.init(frame: .zero, collectionViewLayout: layout)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .clear
        self.register(RecipeItemCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeItemCell")
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        print("Heart button tapped.")
        
        
    }
}
// MARK: - CollectionView FlowLayoutDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = (collectionView.bounds.width - totalSpace) / 2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - RecipeCollectionViewDelegate
extension RecipeCollectionView: RecipeCollectionViewDelegate {
    func didTapFavoriteRecipe(recipe: Recipe) {
        recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
}
// MARK: - UICollectionViewDataSource
extension RecipeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipeModel.getFavoriteRecipeList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        cell.configure(with: recipe)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
}
