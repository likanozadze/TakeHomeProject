//
//  OriginalRecipieView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/21/24.
//

import SwiftUI

struct OriginalRecipeView: View {
    
    // MARK: - Properties
    
    @State private var image: UIImage?
    @State private var recipeName = ""
    @State private var time = ""
    @State private var ingredients = ""
    @State private var instructions = ""
    @State private var imageView = false
    @State private var recipeDetails = ""
    @State private var isLoading = false
    @StateObject private var viewModel = OriginalRecipeViewModel()
    

    var dismissAction: (() -> Void)?

    // MARK: - Body
    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 30) {
                    imagePicView
                    recipeTitleView
                    cookTimeView
                    ingredientsView
                    recipeView
                    saveButton
                    
                }
            }
        }
        .padding(16)
        .fullScreenCover(isPresented: $imageView, onDismiss: nil) {
            ImagePicker(image: $image)
                .ignoresSafeArea()
        }
    }
    
    
    private var imagePicView: some View {
        Button {
            imageView.toggle()
        } label: {
            
            VStack {
                if let image = self.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 170)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                } else {
                    VStack(spacing: 10) {
                        Image(systemName: "photo")
                            .font(.system(size: 40))
                            .foregroundColor(.testColorSet)
                            .frame(height: 170)
                            .frame(maxWidth: .infinity)
                            .clipShape(RoundedRectangle(cornerRadius: 18))
                        Text("Add recipe cover image")
                            .foregroundColor(.testColorSet)
                    }
                }
            }
        }
        
    }
    private var recipeTitleView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Title")
                .font(.system(size: 18))
                .foregroundColor(.testColorSet)
            TextField("Recipe Title", text: $recipeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .foregroundColor(.testColorSet)
                .font(.system(size: 14))
        }
    }
    
    
    private var cookTimeView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Cook Time")
                .font(.system(size: 18))
                .foregroundColor(.testColorSet)
            
            HStack(spacing: 10) {
               
                TextField("time", text: $time)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .foregroundColor(.testColorSet)
                    .font(.system(size: 14))
                Image(systemName: "clock")
                    .font(.system(size: 14, weight: .bold))
                    .padding()
                    .foregroundStyle(.testButton)
                    .frame(width: 40, height: 25)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
    
    private var ingredientsView: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            Text("Ingredients")
                .font(.system(size: 18))
                .foregroundColor(.testColorSet)
            HStack {
                TextField("put ingredients here", text: $ingredients)
                    .frame(height: 45)
                    .font(.system(size: 14))
                    .foregroundColor(.testColorSet)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button(action: {
                    addIngredient()
                }) {
                    Image(systemName: "plus")
                        .font(.system(size: 14, weight: .bold))
                        .padding()
                        .foregroundStyle(.testButton)
                        .frame(width: 40, height: 25)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .textFieldStyle(DefaultTextFieldStyle())
            .clipShape(RoundedRectangle(cornerRadius: 18))
            
            ingredientsListView
        }
    }
    
    private var ingredientsListView: some View {
        
        ForEach(viewModel.ingredientsList, id: \.self) { item in
            VStack {
                HStack {
                    Text(item)
                        .font(.system(size: 14))
                        .foregroundStyle(.testColorSet)
                    Spacer()
                    Button(action: {
                        viewModel.removeIngredient(item: item)
                    }) {
                        Image(systemName: "minus.circle")
                            .font(.system(size: 15))
                            .foregroundStyle(.testButton)
                    }
                }
                Rectangle()
                    .fill(.testButton)
                    .frame(height: 0.3)
                
            }
        }
    }
    
    private var recipeView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions")
                .font(.system(size: 18))
                .foregroundColor(.testColorSet)
            TextEditor(text: $instructions)
                .multilineTextAlignment(.leading)
                .frame(minHeight: 100)
                .font(.system(size: 18))
                .background(.testColorSet)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
    
    private var saveButton: some View {
        ButtonView(text: "Save") {
            Task {
                await addRecipe()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                  dismissAction?()
            }
        }
    }
    // MARK: - Private Functions
    
    private func addIngredient() {
        guard !ingredients.isEmpty else { return }
        viewModel.ingredientsList.append(ingredients)
        ingredients = ""
    }
    
        private func addRecipe() async {
            isLoading = true
            let timeInt = Int(time) ?? 0
            let idString = UUID().uuidString
            let recipeData = OriginalRecipesData(id: idString, name: recipeName, image:  "image", time: timeInt, ingredients: viewModel.ingredientsList, recipe: instructions)
    
            do {
                try await viewModel.updateRecipeInfo(recipeData: recipeData, image: image)
            } catch {
                print("Failed to add: \(error)")
            }
        }
    }
    


#Preview {
    OriginalRecipeView()
}
