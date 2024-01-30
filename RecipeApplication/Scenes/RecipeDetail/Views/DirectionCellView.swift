//
//  DirectionCellView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//

import SwiftUI

struct DirectionCellView: View {
    var recipe: Recipe
    var analyzedInstructions: [AnalyzedInstruction]
    
    // MARK: - Body
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            ScrollView(showsIndicators: false) {
                if let instructions = recipe.instructions {
                    ForEach(instructions.components(separatedBy: "\n"), id: \.self) { step in
                        HStack(alignment: .top) {
                            Image(systemName: "square")
                                .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                                .font(.system(size: 25))

                            Text(step)
                        }
                        Divider().background(Color.gray.opacity(0.2))
                    }
                } else {
                    Text("No instructions available.")
                        .foregroundColor(.gray)
                }
            }
            .padding()

            Spacer()

            ProgressBarView()
                .frame(height: 20)
        }
    }
}


//struct DirectionCellView_Previews: PreviewProvider {
//    static var previews: some View {
//        DirectionCellView(recipe: dummyRecipe)
//    }
//}
