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
    // private var recipes = Recipe()
    
    
    init(networkManager: NetworkManager = .shared) {
        self.networkManager = networkManager
    }
    func viewDidLoad() {
        //   fetchRecipes()
    }
    
    //    private func fetchRecipes() {
    //        let urlStr = "https://spoonacular-recipe-food-nutrition-v1.p.rapidapi.com/recipes/complexSearch?query=pasta&cuisine=italian&diet=vegetarian&instructionsRequired=true&fillIngredients=false&addRecipeInformation=true&ignorePantry=true&sort=calories&sortDirection=asc&limitLicense=false&ranking=2&api_key=28a6562083mshbda012034393b2fp18407ejsn0625c19aebbe"
    //
    //        networkManager.fetchData(fromURL: urlStr) { [weak self] (result: Result<RecipeResponse, Error>) in
    //            switch result {
    //            case .success(let recipeResponse):
    //                self?.recipes = recipeResponse.results
    //                self?.delegate?.recipesFetched(recipeResponse.results)
    //            case .failure(let error):
    //                self?.delegate?.recipeFetchError(error)
    //            }
    //        }
    //    }
    //}
}
