//
//  HomeViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
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
            let baseURL = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com"
           let apiKey = "28a6562083mshbda012034393b2fp18407ejsn0625c19aebbe"
            let endpoint = "/recipes/search"
            let parameters: [String: Any] = [
                "query": "burger",
                "number": 10,
                "apiKey": apiKey,
                "imageSize": 200,
                "addRecipeInformation": true,
                "addRecipeNutrition": false
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
                    case .failure(let error):
                        print("Error fetching data:", error)
                        self.delegate?.recipeFetchError(error)
                    }
                }
            )
        }
    }
//    func fetchRecipes() {
//        let baseURL = "https://api.spoonacular.com"
//        let apiKey = "28bf345135c7408d9307606431071aac"
//        let endpoint = "/recipes/search"
//        let parameters: [String: Any] = [
//            "apiKey": apiKey,
//            "number": 10, // number of recipes to fetch
//            "query": "burger",
//            "minCalories": 50, // min calories
//            "maxCalories": 800, // max calories
//            "imageSize": 200, // image size in pixels
//            "addRecipeInformation": true, // include recipe information
//            "addRecipeNutrition": false // exclude recipe nutrition
//        ]
//        
//        networkManager.request(
//            baseURL: baseURL,
//            apiKey: apiKey,
//            endpoint: endpoint,
//            parameters: parameters,
//            completion: { (result: Result<RecipeSearchResponse, NetworkError>) in
//                switch result {
//                case .success(let fetchedRecipes):
//                    print("Data fetched successfully:", fetchedRecipes)
//                    self.delegate?.recipesFetched(fetchedRecipes.results)
//                case .failure(let error):
//                    print("Error fetching data:", error)
//                    self.delegate?.recipeFetchError(error)
//                }
//            }
//        )
//    }
//}
