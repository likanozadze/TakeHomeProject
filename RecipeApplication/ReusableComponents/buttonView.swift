//
//  buttonView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/21/24.
//

import SwiftUI

struct ButtonView: View {
    var text: String
    var action: (() -> Void)
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.testColorSet)
                .font(.system(size: 16, weight: .semibold))
        })
        .frame(height: 45)
        .frame(maxWidth: .infinity)
        .background(.testButton)
        .cornerRadius(10)
        
        }
    }


