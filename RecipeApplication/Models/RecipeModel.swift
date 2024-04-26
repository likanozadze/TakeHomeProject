//
//  RecipeSearchModel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/25/24.
//

import Foundation

// MARK: - RecipeResponse
struct RecipeResponse: Codable {
    let results: [Recipe]
    let offset: Int
    let number: Int?
    let totalResults: Int
}

// MARK: - Recipe
struct Recipe: Codable {
    let id: Int?
    let title: String?
    let image: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceName: String?
    let sourceUrl: String?
    let spoonacularSourceUrl: String?
    let vegetarian: Bool?
    let vegan: Bool?
    let dishTypes: [String]?
    let glutenFree: Bool?
    let dairyFree: Bool?
    let veryHealthy: Bool?
    let cheap: Bool?
    let veryPopular: Bool?
    let sustainable: Bool?
    let pricePerServing: Double?
    let instructions: String?
    let analyzedInstructions: [AnalyzedInstruction]?
    let originalId: Int?
    let originalTitle: String?
    let originalImage: String?
    var extendedIngredients: [ExtendedIngredient]?
}

// MARK: - ExtendedIngredient
struct ExtendedIngredient: Codable, Identifiable, Hashable {
    let id: Int
    var image: String?
    let name: String
    let original: String
    let originalName: String
    let amount: Double
    let unit: String
    let measures: Measures
   
    func hash(into hasher: inout Hasher) {
           hasher.combine(id)
       }

       static func == (lhs: ExtendedIngredient, rhs: ExtendedIngredient) -> Bool {
           return lhs.id == rhs.id
       }
    
    init(id: Int, image: String, name: String, original: String, originalName: String, amount: Double, unit: String, measures: Measures) {
        self.id = id
        self.image = image
        self.name = name
        self.original = original
        self.originalName = originalName
        self.amount = amount
        self.unit = unit
        self.measures = measures
    }
}

// MARK: - Measures
struct Measures: Codable {
    let us: Us
    let metric: Metric
}

// MARK: - Us
struct Us: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

// MARK: - Metric
struct Metric: Codable {
    let amount: Double
    let unitShort: String
    let unitLong: String
}

// MARK: - AnalyzedInstruction
struct AnalyzedInstruction: Codable, Hashable {
    let id: Int?
    let number: Int?
    let step: String?
    let ingredients: [Ingredient]?
    let equipment: [Equipment]?
    let steps: [Step]?
}

// MARK: - Step
struct Step: Identifiable, Codable, Hashable {
    var id: UUID?
    let number: Int
    let step: String
    let ingredients: [Ingredient]
    let equipment: [Equipment]
    
    init(id: UUID? = nil, number: Int, step: String, ingredients: [Ingredient], equipment: [Equipment]) {
        self.id = UUID()
        self.number = number
        self.step = step
        self.ingredients = ingredients
        self.equipment = equipment
    }
}

// MARK: - Ingredient
struct Ingredient: Decodable, Hashable, Encodable {
    let id: Int
    let name: String
    let localizedName: String
    let image: String
    let quantity: Double?
    
    enum CodingKeys: String, CodingKey {
        case id, name, localizedName, image, quantity
    }
}

// MARK: - Equipment
struct Equipment: Codable, Hashable {
    let id: Int
    let name: String
}
