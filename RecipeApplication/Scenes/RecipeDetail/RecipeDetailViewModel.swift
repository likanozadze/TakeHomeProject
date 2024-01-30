//
//  RecipeDetailViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//


import Foundation
import SwiftUI
import NetworkLayer

//class RecipeDetailViewModel: ObservableObject {
//    @Published var recipe: Recipe
//    @Published var extendedIngredients: [ExtendedIngredient] = []
//    @Published var selectedIngredient: ExtendedIngredient?
//    @Published var analyzedInstructions: [AnalyzedInstruction] = []
//    
//    private let apiKey = "28bf345135c7408d9307606431071aac"
//    private let baseURL = "https://api.spoonacular.com/recipes/"
//    
//    
//    init(recipe: Recipe, selectedIngredient: ExtendedIngredient?) {
//        self.recipe = recipe
//        self.selectedIngredient = selectedIngredient
//        fetchIngredients()
//        fetchInstructions()
//    }
//
//
//    func fetchIngredients() {
//        guard let recipeId = recipe.id else { return }
//
//        let urlString = "\(baseURL)\(recipeId)/information?apiKey=\(apiKey)"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error fetching ingredients: \(error)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
//                    DispatchQueue.main.async {
//                        self.recipe.extendedIngredients = recipe.extendedIngredients
//                        self.extendedIngredients = recipe.extendedIngredients ?? []
//
//                    }
//                } catch {
//                    print("Error decoding recipe: \(error)")
//                }
//            }
//        }.resume()
//    }
//
//    func fetchInstructions() {
//        guard let recipeId = recipe.id else { return }
//
//        let urlString = "\(baseURL)\(recipeId)/analyzedInstructions?apiKey=\(apiKey)"
//        guard let url = URL(string: urlString) else { return }
//
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                print("Error fetching instructions: \(error)")
//                return
//            }
//
//            if let data = data {
//                do {
//                    let decodedInstructions = try JSONDecoder().decode([AnalyzedInstruction].self, from: data)
//                    DispatchQueue.main.async {
//                        self.analyzedInstructions = decodedInstructions
//                    }
//                } catch {
//                    print("Error decoding instructions: \(error)")
//                    DispatchQueue.main.async {
//                    
//                        self.analyzedInstructions = []
//                    }
//                }
//            }
//        }.resume()
//    }
//
//
//}
class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: Recipe
    @Published var extendedIngredients: [ExtendedIngredient] = []
    @Published var selectedIngredient: ExtendedIngredient?
    @Published var analyzedInstructions: [AnalyzedInstruction] = []
    
    private let apiKey = "28bf345135c7408d9307606431071aac"
    private let baseURL = "https://api.spoonacular.com/recipes/"
    
    init(recipe: Recipe, selectedIngredient: ExtendedIngredient?) {
        self.recipe = recipe
        self.selectedIngredient = selectedIngredient
        fetchIngredients()
        fetchInstructions()
    }

    func fetchIngredients() {
        guard let recipeId = recipe.id else { return }

        let urlString = "\(baseURL)\(recipeId)/information?apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching ingredients: \(error)")
                return
            }

            if let data = data {
                do {
                    let recipe = try JSONDecoder().decode(Recipe.self, from: data)
                    DispatchQueue.main.async {
                        self.recipe.extendedIngredients = recipe.extendedIngredients
                        self.extendedIngredients = recipe.extendedIngredients ?? []

                    }
                } catch {
                    print("Error decoding recipe: \(error)")
                }
            }
        }.resume()
    }

    func fetchInstructions() {
        guard let recipeId = recipe.id else { return }

        let urlString = "\(baseURL)\(recipeId)/analyzedInstructions?apiKey=\(apiKey)"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error fetching instructions: \(error)")
                return
            }

            if let data = data {
                do {
                    let decodedInstructions = try JSONDecoder().decode([AnalyzedInstruction].self, from: data)
                    DispatchQueue.main.async {
                        self.analyzedInstructions = decodedInstructions
                    }
                } catch {
                    print("Error decoding instructions: \(error)")
                    DispatchQueue.main.async {
                        self.analyzedInstructions = []
                    }
                }
            }
        }.resume()
    }
}
struct IngredientDetailView: View {
    var ingredient: ExtendedIngredient

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Name: \(ingredient.name)")
            Text("Original Name: \(ingredient.originalName)")
            Text("Amount: \(ingredient.amount) \(ingredient.unit)")
            Text("Measures (US): \(ingredient.measures.us.amount) \(ingredient.measures.us.unitShort)")
            Text("Measures (Metric): \(ingredient.measures.metric.amount) \(ingredient.measures.metric.unitShort)")
        }
        .padding()
    }
}
