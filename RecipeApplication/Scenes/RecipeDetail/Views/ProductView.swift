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
    // MARK: - Body
    var body: some View {
        
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
            
            HStack {
                Text(recipe.title)
                    .font(.system(size: 18))
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
                
                Spacer()
                HStack {
                    Image(systemName: "clock")
                        .font(.system(size: 14))
                        .foregroundColor(.primary)
                    
                    Text("\(recipe.readyInMinutes ?? 0) Min")
                        .font(.system(size: 14))
                        .font(.headline)
                        .foregroundColor(.primary)
                }
            }
        }
        .onAppear {

                    if let imageUrlString = recipe.image, let imageUrl = URL(string: imageUrlString) {
                        fetchImage(from: imageUrl)
                    }
                }
            }

            private func fetchImage(from url: URL) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, let image = UIImage(data: data) {
                        DispatchQueue.main.async {
                            self.recipeImage = image
                        }
                    }
                }.resume()
            }
        }


//#Preview {
//    ProductView(recipe: recipe)
//}
