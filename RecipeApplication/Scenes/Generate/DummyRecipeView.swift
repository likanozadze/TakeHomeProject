//
//  DummyRecipeView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/6/24.
//

import SwiftUI

struct DummyRecipeView: View {
    
    var recipe: DRecipe
    @Binding var showingRecipe: Bool
    
    
    // MARK: - Body
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                VStack {
                    Image(recipe.image)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .frame(height: 260)
                    
                    
                    HStack {
                        Text(recipe.title)
                            .font(.system(size: 20))
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        HStack {
                            Image(systemName: "clock")
                                .font(.system(size: 16))
                                .foregroundColor(.primary)
                            
                            Text("\(recipe.cookTime) Min")
                                .font(.system(size: 16))
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
                Spacer()
                Spacer()
                
                HStack() {
                    Text("Ingredients")
                        .underline()
                        .font(.headline)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                
                VStack(alignment: .leading) {
                    
                    
                    ForEach(recipe.ingredients) { ingredient in
                        HStack {
                            
                            Image(systemName: "circle.fill")
                                .foregroundStyle(Color(red: 134/255, green: 191/255, blue: 62/255))
                                .scaleEffect(0.5)
                            Text(ingredient.name)
                                .font(.system(size: 16))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            HStack {
                                Text("\(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)")
                                    .font(.system(size: 16))
                                    .foregroundColor(.black)
                            }
                        }
                        
                        .foregroundStyle(.clear)
                        .frame(height: 20)
                        .background(Color.white)

                        
                    }
                    
                }
                Spacer()
                Spacer()
                
                HStack() {
                    Text("Instructions")
                        .underline()
                        .font(.headline)
                        .fontWeight(.bold)
                        .font(.system(size: 16))
                        .foregroundColor(.black)
                    Spacer()
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(recipe.instructions) { instruction in
                        HStack(alignment: .top){
                            Text("Step \(instruction.id)")
                                        .foregroundColor(.primary)
                                        .fontWeight(.bold)
                                        .font(.system(size: 14))
                            Text(instruction.step)
                                .foregroundColor(.primary)
                                .font(.system(size: 16))
                        }
                        Divider().background(Color(red: 134/255, green: 191/255, blue: 62/255, opacity: 1.0))
                        
                    }
                }
            }
        }
        .padding()
    }
}
struct DummyRecipeView_Previews: PreviewProvider {
    @State static var showingRecipe = false
    static var previews: some View {
        
        DummyRecipeView(recipe: dummyRecipes[1], showingRecipe: $showingRecipe)
    }
}

