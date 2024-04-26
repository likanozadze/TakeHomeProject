//
//  RecipeDetailView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/29/24.
//

import SwiftUI

struct RecipeDetailViewWrapper: View {
    @ObservedObject var viewModel: RecipeDetailViewModel

    var body: some View {
        NavigationView {
            RecipeDetailView(viewModel: viewModel)
                .environmentObject(ShoppingListViewModel.shared)
                     }
    }
}
