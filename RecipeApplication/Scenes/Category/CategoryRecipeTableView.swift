//
//  CategoryRecipeCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import UIKit


// MARK: - RecipeCollectionView
final class CategoryRecipeTableView: UITableView {
    
    
    // MARK: Properties
    var selectedRecipes: [Recipe] = []
    weak var recipeCollectionViewDelegate: RecipeCollectionViewDelegate?
    var recipes: [Recipe] = []
    
    // MARK: - Initialization
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        backgroundColor = .clear
        dataSource = self
        delegate = self
    
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

    
    // MARK: - UICollectionViewDataSource
extension CategoryRecipeTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeItemTableViewCell else { 
            return UITableViewCell()
        }
        
              let recipe = recipes[indexPath.row]
              cell.configure(with: recipe)
        return cell
    }
}
        // MARK: - UICollectionViewDelegate
extension CategoryRecipeTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
            let recipe = recipes[indexPath.row]
            recipeCollectionViewDelegate?.didTapFavoriteRecipe(recipe: recipe)
        }
    }

