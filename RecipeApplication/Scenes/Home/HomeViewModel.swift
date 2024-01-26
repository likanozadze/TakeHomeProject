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
final class HomeViewModel {
    weak var delegate: RecipeListViewModelDelegate?
    private let networkManager: NetworkManager
    private var recipes: [Recipe] = []
    
    
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    func viewDidLoad() {
        fetchRecipes()
        
    }
    
    func fetchRecipes() {
        
        if let savedRecipes = UserDefaults.standard.object(forKey: "recipes") as? Data {
            let decoder = JSONDecoder()
            if let loadedRecipes = try? decoder.decode([Recipe].self, from: savedRecipes) {
                self.delegate?.recipesFetched(loadedRecipes)
                return
            }
        }
        
        let baseURL = "https://api.spoonacular.com"
        let apiKey = "28bf345135c7408d9307606431071aac"
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
            completion: { (result: Result<RecipeSearchResponse, NetworkError>) in
                switch result {
                case .success(let fetchedRecipes):
                    print("Data fetched successfully:", fetchedRecipes)
                    self.delegate?.recipesFetched(fetchedRecipes.results)
                    
                           let encoder = JSONEncoder()
                           if let encoded = try? encoder.encode(fetchedRecipes.results) {
                               UserDefaults.standard.set(encoded, forKey: "recipes")
                           }
                case .failure(let error):
                    print("Error fetching data:", error)
                    self.delegate?.recipeFetchError(error)
                }
            }
        )
    }
}
