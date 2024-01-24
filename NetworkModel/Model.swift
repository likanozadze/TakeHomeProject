//
//  Model.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//

import Foundation

struct RecipeResponse: Codable {
    let results: [Recipe]
    
    
}
struct Recipe: Codable {
    let vegetarian: Bool
    let vegan: Bool
    let glutenFree: Bool
    let dairyFree: Bool
    let veryHealthy: Bool
    let cheap: Bool
    let veryPopular: Bool
    let sustainable: Bool
    let lowFodmap: Bool
    let weightWatcherSmartPoints: Int?
    let gaps: String?
    let preparationMinutes: Int?
    let cookingMinutes: Int?
    let aggregateLikes: Int?
    let healthScore: Int?
    let creditsText: String?
    let sourceName: String?
    let pricePerServing: Double?
    let id: Int?
    let title: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceUrl: String?
    let image: String?
    let imageType: String?
    let summary: String?
    let cuisines: [String]
    let dishTypes: [String]
    let diets: [String]
    let occasions: [String]
    let analyzedInstructions: [AnalyzedInstruction]
    let spoonacularScore: Double?
    let nutrition: Nutrition?
}

struct AnalyzedInstruction: Codable {
    let name: String?
    let steps: [Step]
}

struct Step: Codable {
    let number: Int
    let step: String
    let ingredients: [Ingredient]
    let equipment: [Equipment]
    let length: Length?
}

struct Ingredient: Codable {
    let id: Int?
    let name: String?
    let localizedName: String?
    let image: String?
}

struct Equipment: Codable {
    let id: Int?
    let name: String?
    let localizedName: String?
    let image: String?
}

struct Length: Codable {
    let number: Int?
    let unit: String?
}

struct Nutrition: Codable {
    let nutrients: [Nutrient]
    let properties: [String: Double]?
}
    struct Nutrient: Codable {
        let name: String?
        let amount: Double
        let unit: String?
    }
    
