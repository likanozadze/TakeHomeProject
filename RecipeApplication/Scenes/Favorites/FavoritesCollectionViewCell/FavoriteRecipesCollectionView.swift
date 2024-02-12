//
//  FavoriteRecipeCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//
//
import UIKit

protocol FavoriteRecipeCollectionViewDelegate: AnyObject {
    func didTapFavoriteRecipe(recipe: Recipe)
}

final class FavoriteRecipeCollectionView: UICollectionView {
    
    // MARK: - Properties
    weak var favoriteRecipeDelegate: FavoriteRecipeCollectionViewDelegate?
    private var favoriteRecipes: [Recipe] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let customLayout = UICollectionViewFlowLayout()
        customLayout.scrollDirection = .vertical
        customLayout.minimumInteritemSpacing = 15
        customLayout.minimumLineSpacing = 16
        
        super.init(frame: frame, collectionViewLayout: customLayout)
        translatesAutoresizingMaskIntoConstraints = false
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
extension FavoriteRecipeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let recipe = favoriteRecipes[indexPath.row]
        cell.delegate = self
        cell.configure(with: recipe)
        return cell
    }
}
    // MARK: - UICollectionViewDelegate
    
extension FavoriteRecipeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = favoriteRecipes[indexPath.row]
        favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
}
        
        
        // MARK: - UICollectionViewDelegateFlowLayout
extension FavoriteRecipeCollectionView: UICollectionViewDelegateFlowLayout {
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
        // MARK: - RecipeItemCollectionViewCellDelegate
extension FavoriteRecipeCollectionView: RecipeItemCollectionViewCellDelegate {
        func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
            guard let indexPath = self.indexPath(for: cell), indexPath.row < favoriteRecipes.count else {
                return
            }
            
            let recipe = favoriteRecipes[indexPath.row]
            favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
        }
        
        func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
            guard let indexPath = self.indexPath(for: cell), indexPath.row < favoriteRecipes.count else {
                return
            }
            
            let recipe = favoriteRecipes[indexPath.row]
            favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
        }
        
        // MARK: - Public Methods
        func setFavoriteRecipes(_ recipes: [Recipe]) {
            favoriteRecipes = recipes
            reloadData()
        }
        
    }
