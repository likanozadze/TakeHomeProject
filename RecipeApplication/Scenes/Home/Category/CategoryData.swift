//
//  CategoryData.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/27/24.
//

import UIKit

struct CategoryData {
    let title: String
    let image: UIImage
}

let categoryData: [CategoryData] = [
    CategoryData(title: "Appetizers", image: UIImage(named: "dessert")!),
    CategoryData(title: "Main Dish", image: UIImage(named: "mainDish")!),
    CategoryData(title: "Salads", image: UIImage(named: "dessert")!),
    CategoryData(title: "Pasta", image: UIImage(named: "dessert")!),
    CategoryData(title: "Dessert", image: UIImage(named: "dessert")!),
    CategoryData(title: "Beverages", image: UIImage(named: "dessert")!),
    CategoryData(title: "Soups", image: UIImage(named: "dessert")!),
    CategoryData(title: "Bread", image: UIImage(named: "dessert")!)
   ]
