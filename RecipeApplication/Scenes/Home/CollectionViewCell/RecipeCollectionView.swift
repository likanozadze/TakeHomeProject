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

    weak var recipeCollectionViewDelegate: RecipeCollectionViewDelegate?
    private var recipes: [Recipe] = []
    
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

}
// MARK: - UICollectionViewDataSource
extension RecipeCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            return UICollectionViewCell()
        }
                
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        cell.favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        
        return cell
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? RecipeItemCollectionViewCell,
              let indexPath = self.indexPath(for: cell) else {
            return
        }
        
        let recipe = recipes[indexPath.row]
        
        if sender.isSelected {
            PersistenceManager.updateWith(favorite: recipe, actionType: .add) { error in
                if let error = error {
                    print("Error favoriting recipe: \(error.rawValue)")
                }
            }
        } else {
            PersistenceManager.updateWith(favorite: recipe, actionType: .remove) { error in
                if let error = error {
                    print("Error unfavoriting recipe: \(error.rawValue)")
                }
            }
        }
    }
}
// MARK: - UICollectionViewDelegate
extension RecipeCollectionView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = recipes[indexPath.row]
        recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
}
// MARK: - RecipeCollectionViewDelegate
extension RecipeCollectionView: RecipeCollectionViewDelegate {
    func didTapFavoriteRecipe(recipe: Recipe) {
        recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
    }
}

