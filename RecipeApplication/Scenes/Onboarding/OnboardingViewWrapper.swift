//
//  OnboardingViewWrapper.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/8/24.
//

import SwiftUI

struct OnboardingViewWrapper: View {
    
    var body: some View {
        NavigationView {
            OnboardingView(screens: ScreenView.onboardPages)
        }
    }
}
#Preview {
    OnboardingViewWrapper()
}
