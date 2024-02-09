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
    CategoryData(title: "Main Dish", image: UIImage(named: "mainCourse")!),
    CategoryData(title: "Appetizers", image: UIImage(named: "Entree")!),
    CategoryData(title: "Salads", image: UIImage(named: "Salads")!),
    CategoryData(title: "Pasta", image: UIImage(named: "Pasta")!),
    CategoryData(title: "Dessert", image: UIImage(named: "dessert")!),
    CategoryData(title: "Beverages", image: UIImage(named: "Beverages")!),
    CategoryData(title: "Soups", image: UIImage(named: "Soups")!),
    CategoryData(title: "Bread", image: UIImage(named: "Bread")!)
   ]
