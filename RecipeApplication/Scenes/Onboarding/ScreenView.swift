//
//  ScreenView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/8/24.
//

import SwiftUI

struct ScreenView: Identifiable, Equatable {
    let id = UUID()
    var name: String
    var image: Image
    var description: [String]
    var number: Int
    
    
    static let onboardPages: [ScreenView] = [
        ScreenView(name: "Welcome to Your Recipes App", image: Image("onboarding1"), description: ["Your personal culinary assistant for delightful home cooking experiences."], number: 0),
        ScreenView(name: "Discover a World of Flavors", image: Image("onboarding2"), description: ["Follow step-by-step instructions for each recipe with our guidance"], number: 1),
        ScreenView(name: "Stay Inspired Stay Hungry", image: Image("onboarding3"), description: ["Get regular updates on new recipes, trends and seasonal delights"], number: 2)
    ]
}


