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
    weak var delegate: OnboardingViewDelegate?
    var coordinator: NavigationCoordinator?
    
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
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .background(Color.customBackgroundColor)
        .ignoresSafeArea()
        .navigationBarHidden(true)
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
                UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                delegate?.didCompleteOnboarding()
                coordinator?.presentLoginViewController() 
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
            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
            delegate?.didCompleteOnboarding()
        }, actionText: "Get Started")
    }
    
}

#Preview {
    OnboardingView(screens: ScreenView.onboardPages)
}

