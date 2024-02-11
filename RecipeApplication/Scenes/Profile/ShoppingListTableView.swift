//
//  ShoppingListTableView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//

//import UIKit
//import SwiftUI
//
//
//class ShoppingListTableView: UITableView {
//    var shoppingList: [ExtendedIngredient] = []
//    let shoppingListStore = ShoppingListStore()
//
//    override init(frame: CGRect, style: UITableView.Style) {
//        super.init(frame: frame, style: style)
//        
//        translatesAutoresizingMaskIntoConstraints = false
//
//        register(UITableViewCell.self, forCellReuseIdentifier: "ShoppingListCell")
//        dataSource = self
//        delegate = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
//
//extension ShoppingListTableView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    
//        return  shoppingListStore.items.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
//        let ingredient = shoppingList[indexPath.row]
//        cell.textLabel?.text = "\(ingredient.name) - \(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)"
//    
//        return cell
//    }
//}
//
//extension ShoppingListTableView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("Selected row in table view: \(indexPath.row)")
//    }
//}
//import UIKit
//import SwiftUI
//
//struct ShoppingListView: UIViewControllerRepresentable {
// var shoppingList: [ExtendedIngredient]
// 
//
//
//    func makeUIViewController(context: Context) -> UITableViewController {
//        let tableViewController = UITableViewController()
//        tableViewController.tableView.dataSource = context.coordinator
//        tableViewController.view.backgroundColor = UIColor(red: 99, green: 0.9, blue: 0.9, alpha: 1.0)
//        
//       print("esaris \(shoppingList)")
//        return tableViewController
//        
//        
//    }
//
//
//    func updateUIViewController(_ uiViewController: UITableViewController, context: Context) {
//        context.coordinator.data = shoppingList
//        uiViewController.tableView.reloadData()
//    }
//
//    func makeCoordinator() -> Coordinator {
//        Coordinator(self)
//    }
//
//    class Coordinator: NSObject, UITableViewDataSource {
//        var parent: ShoppingListView
//        var data: [ExtendedIngredient]
//
//        init(_ parent: ShoppingListView) {
//            self.parent = parent
//            self.data = parent.shoppingList
//        }
//
//        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//            data.count
//        }
//
//        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//            let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
//            let ingredient = data[indexPath.row]
//            cell.textLabel?.text = "\(ingredient.name) - \(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)"
//            return cell
//        }
//    }
//}
