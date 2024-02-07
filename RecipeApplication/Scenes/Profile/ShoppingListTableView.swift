//
//  ShoppingListTableView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/31/24.
//

import UIKit


class ShoppingListTableView: UITableView {
    var shoppingList: [ExtendedIngredient] = []
    let shoppingListStore = ShoppingListStore()

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        translatesAutoresizingMaskIntoConstraints = false
      //  backgroundColor = .red
        register(UITableViewCell.self, forCellReuseIdentifier: "ShoppingListCell")
        dataSource = self
        delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ShoppingListTableView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        return  shoppingListStore.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ShoppingListCell", for: indexPath)
        let ingredient = shoppingList[indexPath.row]
        cell.textLabel?.text = "\(ingredient.name) - \(String(format: "%.0f", ingredient.amount)) \(ingredient.unit)"
    
        return cell
    }
}

extension ShoppingListTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected row in table view: \(indexPath.row)")
    }
}
