//
//  ProductView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import SwiftUI

struct ProductView: View {
    var recipe: Recipe
    
    @State private var recipeImage: UIImage? = nil
    @State private var isLoading: Bool = false
    // MARK: - Body
    var body: some View {
        
        VStack(alignment: .leading) {
            Text(recipe.title ?? "Unknown Title")
                .font(.system(size: 18))
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            
            VStack {
                if let recipeImage = recipeImage {
                    Image(uiImage: recipeImage)
                        .resizable()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 200)
                } else {
                    
                    Rectangle()
                        .foregroundColor(.gray)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .frame(height: 200)
                }
                
                Spacer()
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    
                    Text("\(recipe.readyInMinutes ?? 0) Min")
                        .font(.system(size: 14))
                        .font(.headline)
                        .foregroundColor(.primary)
                    Spacer()
                    HStack {
                        Image(systemName: "person")
                            .font(.system(size: 14))
                            .foregroundColor(.primary)
                        
                        if let servings = recipe.servings {
                            Text("\(servings)")
                                .font(.system(size: 14))
                                .font(.headline)
                                .foregroundColor(.primary)
                        }
                    }
                }
            }
        }
    
        .onAppear {
                   loadImage()
               }
           }
           
           private func loadImage() {
               guard let imageUrlString = recipe.image,
                     let imageUrl = URL(string: imageUrlString),
                     !isLoading else { return }
               
               isLoading = true
               
               URLSession.shared.dataTask(with: imageUrl) { data, _, error in
                   defer { isLoading = false }
                   
                   if let data = data, let image = UIImage(data: data) {
                       DispatchQueue.main.async {
                           self.recipeImage = image
                       }
                   } else {
                       print("Failed to load image: \(error?.localizedDescription ?? "Unknown error")")
                   }
               }.resume()
           }
       }


