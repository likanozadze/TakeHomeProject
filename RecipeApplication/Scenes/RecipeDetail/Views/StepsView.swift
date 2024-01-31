//
//  StepsView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//

import SwiftUI
struct StepsSectionView: View {
    var steps: [AnalyzedInstruction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Steps:")
                .font(.headline)
                .padding(.bottom, 5)
            
            ForEach(steps, id: \.self) { stepSection in
                if let steps = stepSection.steps {
                    ForEach(steps, id: \.self) { step in
                        StepView(step: step)
                    }
                }
            }
        }
    }
}


struct StepView: View {
    var step: Step
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(step.number)")
                .font(.headline)
            Text(step.step)
                .font(.body)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.bottom, 8)
    }
}
