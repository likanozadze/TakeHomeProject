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
        customLayout.itemSize = CGSize(width: 340, height: 220)
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
    
    // MARK: - CollectionView FlowLayoutDelegate
extension CategoryRecipeCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
        
        let cellsPerRow: CGFloat = 1.5
        let width = (collectionView.bounds.width - totalSpace) / cellsPerRow
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
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

