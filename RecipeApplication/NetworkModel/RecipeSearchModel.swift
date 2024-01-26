//
//  RecipeSearchModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/25/24.
//

import Foundation

struct RecipeSearchResponse: Decodable {
    let results: [Recipe]
    let offset: Int
    let number: Int?
    let totalResults: Int
}

struct Recipe: Decodable {
    let id: Int
    let title: String
    let image: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceName: String?
    let sourceUrl: String?
    let spoonacularSourceUrl: String?
    let vegetarian: Bool?
    let vegan: Bool?
    let glutenFree: Bool?
    let dairyFree: Bool?
    let veryHealthy: Bool?
    let cheap: Bool?
    let veryPopular: Bool?
    let sustainable: Bool?
    let pricePerServing: Double?
    let extendedIngredients: [ExtendedIngredient]?
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]?
    let originalId: Int?
    let originalTitle: String?
    let originalImage: String?
}

struct ExtendedIngredient: Decodable {
    let id: Int
    let image: String
    let name: String
    let original: String
    let originalName: String
    let amount: Double
    let unit: String
    let measures: Measures
}

struct Measures: Decodable {
    let us: Us
    let metric: Metric
}

struct Us: Decodable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

struct Metric: Decodable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

struct AnalyzedInstruction: Decodable {
    let number: Int?
    let step: String?
    let ingredients: [Ingredient]?
    let equipment: [Equipment]?
}

struct Ingredient: Decodable {
    let id: Int
    let quantity: Double
    let name: String
}

struct Equipment: Decodable {
    let id: Int
    let name: String
}
