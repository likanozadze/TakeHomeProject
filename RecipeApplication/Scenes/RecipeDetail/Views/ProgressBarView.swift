//
//  ProgressBarView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//


import SwiftUI

// MARK: - ProgressBarView

struct ProgressBarView: View {
    
    // MARK: Properties
    var percent: CGFloat
    // MARK: - Body
    
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let multiplier = width / 100
             
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: width, height: 18)
                    .foregroundStyle(Color(red: 134/255, green: 191/255, blue: 62/255, opacity: 0.41))
                
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .frame(width: multiplier * percent, height: 18)
                    .background(Color(red: 134/255, green: 191/255, blue: 62/255)).clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .foregroundStyle(.clear)
            }
        }
    }
}

//#Preview() {
//    
//    ProgressBarView(percent: progress)
//}
