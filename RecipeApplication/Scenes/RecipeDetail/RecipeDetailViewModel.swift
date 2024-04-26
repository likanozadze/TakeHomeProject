//
//  RecipeDetailViewModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import Foundation
import SwiftUI
import NetworkLayer

// MARK: - RecipeDetailViewModel
class RecipeDetailViewModel: ObservableObject {
    
    // MARK: Published Properties
    @Published var recipe: Recipe
    @Published var extendedIngredients: [ExtendedIngredient] = []
    @Published var selectedIngredient: ExtendedIngredient?
    @Published var analyzedInstructions: [AnalyzedInstruction] = []

    // MARK: Private Properties
    private let apiKey = Configuration.apiKey
    private let baseURL = "https://api.spoonacular.com/recipes/"
    private let cache = NSCache<NSString, NSData>()

    
    // MARK: Initialization
    init(recipe: Recipe, selectedIngredient: ExtendedIngredient? = nil) {
        self.recipe = recipe
        self.selectedIngredient = selectedIngredient
        fetchIngredientsFromCache()
        fetchInstructionsFromCache()
        fetchIngredients()
        fetchInstructions()
    }
    
    // MARK: Data Fetching
       func fetchIngredientsFromCache() {
           guard let recipeId = recipe.id else { return }

           if let cachedData = cache.object(forKey: "\(recipeId)-ingredients" as NSString) as Data? {
               do {
                   let recipe = try JSONDecoder().decode(Recipe.self, from: cachedData)
                   self.recipe.extendedIngredients = recipe.extendedIngredients
                   self.extendedIngredients = recipe.extendedIngredients ?? []
               } catch {
                   print("Error decoding cached recipe: \(error)")
               }
           }
       }

       func fetchInstructionsFromCache() {
           guard let recipeId = recipe.id else { return }

           if let cachedData = cache.object(forKey: "\(recipeId)-instructions" as NSString) as Data? {
               do {
                   let decodedInstructions = try JSONDecoder().decode([AnalyzedInstruction].self, from: cachedData)
                   self.analyzedInstructions = decodedInstructions
               } catch {
                   print("Error decoding cached instructions: \(error)")
               }
           }
       }
    // MARK: Data Fetching
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
                print(String(data: data, encoding: .utf8) ?? "Unable to print data")
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
    func cacheData(_ data: Data, forKey key: String) {
          cache.setObject(data as NSData, forKey: key as NSString)
      }
   
  }


// MARK: - IngredientDetailView
struct IngredientDetailView: View {
    
    // MARK: Properties
    var ingredient: ExtendedIngredient

    // MARK: Body
    
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
