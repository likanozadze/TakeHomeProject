//
//  HomeViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//
//

import Foundation
import NetworkLayer

protocol RecipeListViewModelDelegate: AnyObject {
    func recipesFetched(_ recipes: [Recipe])
    func recipeFetchError(_ error: Error)
}

final class HomeViewModel: ObservableObject {
    
    // MARK: - Properties

    weak var delegate: RecipeListViewModelDelegate?
    private let networkManager: NetworkManager
    var recipes: [Recipe] = []
    
    // MARK: - Initialization
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    
    // MARK: - ViewLifecycle
    
    func viewDidLoad() {
        fetchRecipes()
        
    }
    // MARK: - Fetch Recipes
    
    func fetchRecipes() {
        
        if let savedRecipes = UserDefaults.standard.object(forKey: "recipes") as? Data {
            let decoder = JSONDecoder()
            if let loadedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                self.recipes = loadedRecipes
                self.delegate?.recipesFetched(loadedRecipes)
                return
            }
        }
        
        let baseURL = "https://api.spoonacular.com"
        let apiKey = Configuration.apiKey
        let endpoint = "/recipes/complexSearch"
        let parameters: [String: Any] = [
            "apiKey": apiKey,
            "number": 10,
            "addRecipeInformation": true,
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
                    self.delegate?.recipesFetched(fetchedRecipes.results)
                    
                           let encoder = JSONEncoder()
                           if let encoded = try? encoder.encode(fetchedRecipes.results) {
                               UserDefaults.standard.set(encoded, forKey: "recipes")
                           }
                case .failure(let error):
                    self.delegate?.recipeFetchError(error)
                }
            }
        )
    }
}
extension HomeViewModel {
    func recipe(at indexPath: IndexPath) -> Recipe? {
        return recipes[indexPath.item]
    }
}
