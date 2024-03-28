//
//  OriginalRecipeDetailView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/26/24.
//

import SwiftUI

struct OriginalRecipeDetailView: View {
    
    var recipe: OriginalRecipesData
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let imageURL = URL(string: recipe.image) {
                    AsyncImage(url: imageURL) { image in
                        image.resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 200)
                }
                
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    Text("\(recipe.time) min")
                        .font(.system(size: 14))
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                
                VStack(alignment: .leading) {
                    Text("Ingredients")
                        .font(.system(size: 18))
                    
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        HStack {
                            Image(systemName: "circle.fill")
                                .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                                .font(.system(size: 14))
                            Text("\(ingredient)")
                                .font(.system(size: 16))
                                .foregroundColor(.testColorSet)
                                .foregroundStyle(.clear)
                                .frame(height: 30)
                                .cornerRadius(8)
                        }
                        
                        Divider().background(Color.gray.opacity(0.2))
                    }
                    
                    Text("Instructions")
                        .font(.system(size: 18))
                        .foregroundColor(.testColorSet)
                }
                Text(recipe.recipe)
                    .foregroundColor(.testColorSet)
            }
            .padding()
            
            .navigationTitle(recipe.name)
        }
    }
}


#Preview {
    OriginalRecipeDetailView(recipe: OriginalRecipesData(id: "sample-id", name: "Sample Recipe", image: "https://some-image-url.com", time: 60, ingredients: ["Ingredient 1", "Ingredient 2"], recipe: "Step 1... Step 2..."))
}
