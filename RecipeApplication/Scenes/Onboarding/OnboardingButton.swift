//
//  OnboardingButton.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/8/24.
//

import SwiftUI

struct OnboardingButton: View {
    //MARK: - Properties
    var action: () -> Void
    var actionText: String
    
    //MARK: - Body
    var body: some View {
        Button(action: action) {
            PrimaryButtonView(text: actionText)
        }
    }
}
struct PrimaryButtonView: View {
    // MARK: - Properties
    var text: String
    
    // MARK: - Body
    var body: some View {
            Text(text)
                .foregroundStyle(.white)
                .font(.system(size: 16))
                .fontWeight(.bold)
                .frame(maxWidth: .infinity)
                .frame(height: 48)
                .background(Color.customButtonBackgroundColor)
                .cornerRadius(10)
                .padding(.horizontal, 16)
        }
    }


import SwiftUI

extension Color {
    static let customBackgroundColor = Color(red: 244/255, green: 245/255, blue: 245/255)
    static let customButtonBackgroundColor = Color(red: 134/255, green: 191/255, blue: 62/255)
}

