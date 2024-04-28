//
//  CategoryRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/5/24.
//

import UIKit
import SwiftUI

// MARK: - RecipeDelegate
final class CategoryRecipeViewController: UIViewController, RecipeItemCollectionViewCellDelegate {
    
    // MARK: Properties
    
    var categoryViewModel = CategoryViewModel()
    var selectedCategory: String?
    private let viewModel = HomeViewModel()
    var categoryRecipeTableView = CategoryRecipeTableView()
    private var recipe: [Recipe] = []
    private var selectedRecipes: [Recipe] = []
    var coordinator: NavigationCoordinator?
    weak var delegate: RecipeItemCollectionViewCellDelegate?
    
    private let recipeSearchBar = RecipeSearchBar()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
       viewModel.viewDidLoad()
       recipeSearchBar.delegate = self
        categoryRecipeTableView.register(RecipeItemTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
    
        coordinator = NavigationCoordinator(navigationController: navigationController!)
                coordinator?.delegate = self
        categoryRecipeTableView.delegate = self
        categoryRecipeTableView.dataSource = self
        
        if let selectedCategory = selectedCategory {
            categoryViewModel.delegate = self
            categoryViewModel.fetchRecipesByTag(selectedCategory)
        }
    }
    
    // MARK: - UI Setup
    
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
    }
    
    // MARK: - Private Methods
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(recipeSearchBar)
        mainStackView.addArrangedSubview(categoryRecipeTableView)
    }
    
    func setupConstraints() {
        
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])

    }
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
}

    // MARK: - CategoryListViewModelDelegate

    extension CategoryRecipeViewController: CategoryListViewModelDelegate {
    func categoriesFetched(_ recipes: [Recipe]) {
        self.recipe = recipes
        DispatchQueue.main.async {
            self.categoryRecipeTableView.reloadData()
        }
    }

    func categoryFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    
    }
}

// MARK: - UITableViewDataSource

extension CategoryRecipeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableViewCell", for: indexPath) as? RecipeItemTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(with: recipe[indexPath.row])
        return cell
    }
}



extension CategoryRecipeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let recipe = categoryViewModel.recipe(at: indexPath) {
            coordinator?.didSelectRecipe(recipe: recipe)
        }
    }
}

// MARK: - NavigationCoordinatorDelegate
extension CategoryRecipeViewController: NavigationCoordinatorDelegate {
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        coordinator?.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
    }
    
    func didSelectRecipe(recipe: Recipe) {
        coordinator?.didSelectRecipe(recipe: recipe)
    }
    
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        coordinator?.didSelectRecipe(on: cell)
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        coordinator?.didTapFavoriteButton(on: cell)
    }
}

extension CategoryRecipeViewController: RecipeListViewModelDelegate {
    func recipesFetched(_ recipe: [Recipe]) {
        self.recipe = recipe
        DispatchQueue.main.async {
            self.categoryRecipeTableView.reloadData()
        }
    }
    
    func recipeFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    }
}

extension CategoryRecipeViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        viewModel.searchRecipes(query)
    }
}


extension CategoryRecipeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
          
            categoryViewModel.fetchRecipesByTag(selectedCategory ?? "")
        } else {
     
            viewModel.searchRecipes(searchText)
        }
    }
}
