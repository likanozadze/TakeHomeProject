//
//  StepsView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//

import SwiftUI

struct StepsSectionView: View {
    
    var steps: [AnalyzedInstruction]
    
    @State private var progress: CGFloat = 0
    @State private var completedSteps: [Int: Bool] = [:]
    
    // MARK: - Body
    
    var body: some View {
      
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                ForEach(steps, id: \.self) { stepSection in
                    if let steps = stepSection.steps {
                        ForEach(steps, id: \.self) { step in
                            
                            HStack(alignment: .top) {
                                Image(systemName: completedSteps[step.number, default: false] ? "checkmark.square" : "square")
                                    .foregroundColor(Color(red: 134/255, green: 191/255, blue: 62/255))
                                    .font(.system(size: 25))
                               
            
                                StepView(step: step)
                            }
                            .onTapGesture {
                                if completedSteps[step.number, default: false] {
                                    completedSteps[step.number] = false
                                    progress -= 100 / CGFloat(steps.count)
                                } else {
                                    completedSteps[step.number] = true
                                    progress += 100 / CGFloat(steps.count)
                                }
                            }
                            Divider().background(Color.gray.opacity(0.2))
                        }
                    }
                }
            }
        }
        Spacer()
        
        ProgressBarView(percent: progress)
            .frame(height: 20)
    }
}

struct StepView: View {
    var step: Step
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(step.step)
                .font(.body)
        }
    }
}
