//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//
//


import UIKit
import SwiftUI

// MARK: - HomeViewController
final class HomeViewController: UIViewController, RecipeItemCollectionViewCellDelegate, UITableViewDelegate {
    
    
    // MARK: - Properties
    private var selectedRecipes: [Recipe] = []
    private var recipe: [Recipe] = []
    private let viewModel = HomeViewModel()
    private var fetchedRecipes: [Recipe] = []
    private var categoryCollectionView = CategoryCollectionView()
    private let recipeCollectionView = RecipeCollectionView()
    var coordinator: NavigationCoordinator?
    private let recipeSearchBar = RecipeSearchBar()
    var filteredRecipes: [Recipe] = []
    
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let categoryTitle: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = .testColorSet
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Trending Now 🔥"
        label.textColor = .testColorSet
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let recipeTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private let categoryTitleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(RecipeItemTableViewCell.self, forCellReuseIdentifier: "RecipeTableViewCell")
        return tableView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
        recipeCollectionView.dataSource = self
        recipeCollectionView.delegate = self
        categoryCollectionView.delegate = self
        coordinator?.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        
        
        recipeSearchBar.delegate = self
        
        if let layout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupTitleStackView()
        setupConstraints()
        tableView.backgroundColor = .red
        tableView.separatorColor = .systemGray3
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
        view.addSubview(tableView)
        mainStackView.addArrangedSubview(recipeSearchBar)
        mainStackView.addArrangedSubview(categoryTitleStackView)
        mainStackView.addArrangedSubview(categoryCollectionView)
        mainStackView.addArrangedSubview(recipeTitleStackView)
        mainStackView.addArrangedSubview(recipeCollectionView)
    }
    
    private func setupTitleStackView() {
        recipeTitleStackView.addArrangedSubview(recipeTitle)
        categoryTitleStackView.addArrangedSubview(categoryTitle)
        
    }
    
    private func setupConstraints() {
        
        
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 120),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            
        ])
        
    }
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    private func addDelegate() {
        recipeSearchBar.delegate = self
    }
    
}

// MARK: - CollectionView DataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recipe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.configure(with: recipe[indexPath.row])
        return cell
        
    }
}

// MARK: - CollectionView Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == recipeCollectionView {
            if let recipe = viewModel.recipe(at: indexPath) {
                let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: recipe.extendedIngredients?[indexPath.row])
                let detailWrapper = RecipeDetailViewWrapper(viewModel: detailViewModel)
                let hostingController = UIHostingController(rootView: detailWrapper)
                navigationController?.pushViewController(hostingController, animated: true)
            }
        } else {
            let selectedTag = categoryData[indexPath.row].title.lowercased()
            let categoryRecipeViewController = CategoryRecipeViewController()
            
            categoryRecipeViewController.selectedCategory = selectedTag
            categoryRecipeViewController.categoryViewModel.fetchRecipesByTag(selectedTag)
            categoryRecipeViewController.categoryViewModel.recipes = recipe
            navigationController?.pushViewController(categoryRecipeViewController, animated: true)
            
        }
    }
}

// MARK: - CollectionView FlowLayoutDelegate

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == recipeCollectionView {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left
            
            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing
            
            let width = (collectionView.bounds.width - totalSpace) / 2
            let height = width * 1.5
            
            return CGSize(width: width, height: height)
            
        } else {
            
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let totalSpace = flowLayout.sectionInset.left

            + flowLayout.sectionInset.right
            + flowLayout.minimumInteritemSpacing

            let width = (collectionView.bounds.width - totalSpace) / 2
            let height = width * 0.5
            
            return CGSize(width: width, height: height)
        }
    }
}


// MARK: - RecipeListViewModelDelegate

extension HomeViewController: RecipeListViewModelDelegate {
    
    func recipesFetched(_ recipes: [Recipe]) {
        self.recipe = recipes
        //        recipeCollectionView.reloadData()
        //        tableView.reloadData()
        //    }
        DispatchQueue.main.async {
            self.recipeCollectionView.reloadData()
            self.tableView.reloadData()
        }
    }
    
    func recipeFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    }
}
// MARK: - NavigationCoordinatorDelegate
extension HomeViewController: NavigationCoordinatorDelegate {
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

extension HomeViewController: RecipeSearchBarDelegate {
    func didChangeSearchQuery(_ query: String?) {
        viewModel.searchRecipes(query)
        tableView.reloadData()
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeItemTableViewCell", for: indexPath) as! RecipeItemTableViewCell
        cell.configure(with: filteredRecipes[indexPath.row])
        return cell
    }
}
extension HomeViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredRecipes = viewModel.recipes
        } else {
            filteredRecipes = viewModel.recipes.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
        viewModel.searchRecipes(searchText)
        tableView.reloadData()
    }
}
