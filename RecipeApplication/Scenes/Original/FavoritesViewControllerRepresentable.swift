//
//  FavoritesViewControllerRepresentable.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 4/20/24.
//

import SwiftUI

struct FavoritesViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = FavoritesViewController

    func makeUIViewController(context: Context) -> FavoritesViewController {
        let favoritesViewController = FavoritesViewController()
        return favoritesViewController
    }

    func updateUIViewController(_ uiViewController: FavoritesViewController, context: Context) {
    }
}
