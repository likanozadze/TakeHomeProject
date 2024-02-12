//
//  PageView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/8/24.
//

import SwiftUI

struct PageView: View {
    
    //MARK: - Properties
    var screen: ScreenView
    
    //MARK: - Body
    var body: some View {
        VStack(alignment: .leading ,spacing: 20) {
            onboardingImage
            titleText
            descriptionStack
        }
        .padding(20)
    }
}


//MARK: - Content
extension PageView {
    private var onboardingImage: some View {
        GeometryReader { geometry in
            screen.image
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .clipped()
                .cornerRadius(10)
        }
    }
    private var titleText: some View {
        HStack {
            Text(screen.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
            Spacer()
        }
    }
    
    private var descriptionStack: some View {
        VStack(alignment: .leading) {
            ForEach(screen.description.indices, id: \.self) { index in
                DescriptionText(text: screen.description[index])
            }
        }
    }
    
    struct DescriptionText:  View {
        var text: String
        
        var body: some View {
            HStack {
                Text(text)
                    .foregroundStyle(.black)
                    .font(.system(size: 16))
            }
        }
    }
}

