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

final class FavoriteRecipeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, RecipeItemCollectionViewCellDelegate {
    
    // MARK: - Properties
    var favoriteRecipeModel = FavoriteRecipeModel()
    weak var favoriteRecipeDelegate: FavoriteRecipeCollectionViewDelegate?
    
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
    
    // MARK: - UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipeModel.getFavoriteRecipeList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        cell.delegate = self
        cell.configure(with: recipe)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
    
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = (collectionView.bounds.width - totalSpace) / 2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: - RecipeItemCollectionViewCellDelegate
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = self.indexPath(for: cell) else {
            return
        }
        
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let indexPath = indexPath(for: cell) {
            let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
            favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
        }
    }
}
