//
//  ButtonView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//
import SwiftUI

struct ButtonView: View {
    
    // MARK: - Body
    var body: some View {
        Button(action: {

        }, label: {
            Text("Add to shopping list")
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .foregroundColor(.white)
                .font(.system(size: 16, weight: .semibold))
                .background(Color(red: 134/255, green: 191/255, blue: 62/255))
                .cornerRadius(10)
        })
    }
}

struct ButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonView()
    }
}
