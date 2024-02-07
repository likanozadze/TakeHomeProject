//
//  OnboardingView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/8/24.
//

import SwiftUI

struct OnboardingView: View {
    //MARK: - Properties
    @State private var screenIndex = 0
    private let screens: [ScreenView]
    
    // Public initializer
      init(screens: [ScreenView]) {
          self.screens = screens
      }
    
    var body: some View {
        onboarding
    }
}
extension OnboardingView {
    private var onboarding: some View {
        TabView(selection: $screenIndex) {
            boardingScreens
        }
        .animation(.easeInOut, value: screenIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .background(Color.customBackgroundColor).ignoresSafeArea()
    }
    
    private var boardingScreens: some View {
        ForEach(screens) { screen in
            VStack {
                skipButton
                PageView(screen: screen)
                Spacer()
                if screen == screens.last {
                    getStartedButton
                } else {
                    nextButton
                }
                Spacer(minLength: 50)
            }
          .tag(screen.number)
        }
    }
    
    private func changeScreen() {
        screenIndex += 1
    }
    
    private func resetScreen() {
        screenIndex = 0
    }
    
    private var skipButton: some View {
        HStack{
            Spacer()
            Button(action: {
                
            }) {
                Text("Skip")
                    .foregroundColor(.black)
                    .underline()
            }
            .padding()
        }
    }
    
    private var nextButton: some View {
        OnboardingButton(action: changeScreen, actionText: "Next")
    }
    
    private var getStartedButton: some View {
        OnboardingButton(action: {
        }, actionText: "Get Started")
    }
}

#Preview {
    OnboardingView(screens: ScreenView.onboardPages)
}
