//
//  DirectionCellView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/30/24.
//
import SwiftUI
struct InstructionView: View {
    var instruction: AnalyzedInstruction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(instruction.number ?? 0)")
                .font(.headline)
            Text(instruction.step ?? "No description")
                .font(.body)
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(8)
        .padding(.bottom, 8)
    }
}
struct ContentView: View {
    var instructions: [AnalyzedInstruction]

    var body: some View {
        VStack {
            ForEach(instructions, id: \.self) { analyzedInstruction in
                InstructionView(instruction: analyzedInstruction)
            }
        }
    }
}
