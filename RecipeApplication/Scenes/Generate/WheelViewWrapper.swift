//
//  WheelViewWrapper.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/28/24.
//
import SwiftUI

struct WheelViewWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UIHostingController(rootView: WheelView())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
       
    }
}
