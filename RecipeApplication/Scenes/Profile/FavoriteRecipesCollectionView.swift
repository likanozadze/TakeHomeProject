//
//  FavoriteRecipeCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//

import UIKit
protocol FavoriteRecipeCollectionViewDelegate: AnyObject {
    func didTapFavoriteRecipe(recipe: Recipe)
}

final class FavoriteRecipeCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var favoriteRecipeModel = FavoriteRecipeModel()
    
    weak var favoriteRecipeDelegate: FavoriteRecipeCollectionViewDelegate?

    // MARK: - Init
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let customLayout = UICollectionViewFlowLayout()
        customLayout.scrollDirection = .horizontal
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
        self.register(FavoriteRecipeCell.self, forCellWithReuseIdentifier: "favoriteCell")
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteRecipeModel.getFavoriteRecipeList().count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favoriteCell", for: indexPath) as? FavoriteRecipeCell else {
            return UICollectionViewCell()
        }
        
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        cell.configure(with: recipe)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = favoriteRecipeModel.getFavoriteRecipeList()[indexPath.row]
        favoriteRecipeDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }


    // MARK: - CollectionView FlowLayoutDelegate

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
    
