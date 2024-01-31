//
//  ButtonView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//
import SwiftUI

struct ButtonView: View {
    @Binding var isAnyItemSelected: Bool
    
    // MARK: - Body
    var body: some View {
        Button(action: {
        }, label: {
            Text("Add to shopping list")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .background(isAnyItemSelected ? Color(red: 134/255, green: 191/255, blue: 62/255) : Color(red: 0.89, green: 0.90, blue: 0.91))
                .cornerRadius(10)
        })
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView(isAnyItemSelected: .constant(false))
    }
}
