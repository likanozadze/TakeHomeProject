//
//  CategoryViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import Foundation
import NetworkLayer

// MARK: - CategoryListViewModelDelegate

protocol CategoryListViewModelDelegate: AnyObject {
    func categoriesFetched(_ recipes: [Recipe])
    func categoryFetchError(_ error: Error)
}

// MARK: - CategoryViewModel

final class CategoryViewModel {
    
    // MARK: Properties
    
    weak var delegate: CategoryListViewModelDelegate?
    private let networkManager: NetworkManager
    var recipes: [Recipe] = []
    var recipeCache: [String: [Recipe]] = [:]
    
    // MARK: Initialization
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    
    func fetchRecipesByTag(_ tag: String) {
        
       
        if let cachedRecipes = recipeCache[tag] {
            self.recipes = cachedRecipes
            self.delegate?.categoriesFetched(cachedRecipes)
            return
        }
        

        let baseURL = "https://api.spoonacular.com"
        let apiKey = "eb79c4da71b448b4b7477dde8216b951"
        let endpoint = "/recipes/complexSearch"
        let parameters: [String: Any] = [
            "apiKey": apiKey,
            "number": 10,
            "type": tag.lowercased().replacingOccurrences(of: " ", with: "+")
        ]
        
        networkManager.request(
            baseURL: baseURL,
            apiKey: apiKey,
            endpoint: endpoint,
            parameters: parameters,
            completion: { (result: Result<RecipeResponse, NetworkError>) in
                switch result {
                case .success(let fetchedRecipes):
                    print("Data fetched successfully:", fetchedRecipes)
                    self.recipes = fetchedRecipes.results
                    // Update the cache
                    self.recipeCache[tag] = fetchedRecipes.results
                    self.delegate?.categoriesFetched(fetchedRecipes.results)
                    
                case .failure(let error):
                    print("Error fetching data:", error)
                    self.delegate?.categoryFetchError(error)
                }
            }
        )
    }
}

// MARK: - CategoryViewModel Extension

extension CategoryViewModel {
    func recipe(at indexPath: IndexPath) -> Recipe? {
        return recipes[indexPath.item]
    }
}
