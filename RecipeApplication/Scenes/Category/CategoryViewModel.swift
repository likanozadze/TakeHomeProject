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

    
    // MARK: Initialization
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // MARK: Public Methods
    
    func fetchRecipesByTag(_ tag: String) {
        if let savedRecipes = UserDefaults.standard.object(forKey: tag) as? Data {
                   let decoder = JSONDecoder()
                   if let loadedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                       self.recipes = loadedRecipes
                       DispatchQueue.main.async {
                           self.delegate?.categoriesFetched(loadedRecipes)
                       }
                       return
                   }
               }


        let baseURL = "https://api.spoonacular.com"
        let apiKey = Configuration.apiKey
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
                    self.recipes = fetchedRecipes.results
                    let encoder = JSONEncoder()
                                     if let encoded = try? encoder.encode(fetchedRecipes.results) {
                                         UserDefaults.standard.set(encoded, forKey: tag)
                                     }
                                     DispatchQueue.main.async {
                                         self.delegate?.categoriesFetched(fetchedRecipes.results)
                                     }
                    
                case .failure(let error):
                    print("Error fetching data:", error)
                    DispatchQueue.main.async {
                        self.delegate?.categoryFetchError(error)
                    }
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
