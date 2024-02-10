////
////  SearchViewModel.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/27/24.
////
////
//import Foundation
//import NetworkLayer
//
//protocol SearchViewModelDelegate: AnyObject {
//    func searchResultsFetched(_ recipes: [SearchData])
//    func searchError(_ error: Error)
//    func searchStarted()
//}
//
//final class SearchViewModel {
//    weak var delegate: SearchViewModelDelegate?
//    var recipes: [SearchData] = []
//
//    func searchRecipes(for query: String) {
//        guard !query.isEmpty else {
//          
//            self.delegate?.searchResultsFetched([])
//            return
//        }
//
//       
//        self.delegate?.searchStarted()
//
//        let baseURL = "https://api.spoonacular.com"
//      let apiKey = Configuration.apiKey
//        let endpoint = "/recipes/autocomplete"
//        let parameters: [String: Any] = [
//          "apiKey": apiKey,
//            "query": query,
//            "number": 25
//        ]
//
//        let networkManager = NetworkManager.shared
//
//        networkManager.request(
//            baseURL: baseURL,
//           apiKey: apiKey,
//            endpoint: endpoint,
//            parameters: parameters,
//            completion: { [weak self] (result: Result<[SearchData], NetworkError>) in
//                guard let self = self else { return }
//
//                switch result {
//                case .success(let searchData):
//                    print("Search data fetched successfully:", searchData)
//                    self.recipes = searchData
//                    self.delegate?.searchResultsFetched(searchData)
//                case .failure(let error):
//                    print("Error fetching search data:", error)
//                    self.delegate?.searchError(error)
//                }
//            }
//        )
//    }
//}
