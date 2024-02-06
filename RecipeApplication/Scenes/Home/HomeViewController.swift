//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//
//

import UIKit
import SwiftUI

// MARK: - RecipeDelegate
protocol RecipeDelegate: AnyObject {
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe])
    func didSelectRecipe(recipe: Recipe)
}

// MARK: - HomeViewController
final class HomeViewController: UIViewController {
    
    
    // MARK: - Properties
    var favoriteRecipeModel = FavoriteRecipeModel()
    private var selectedRecipes: [Recipe] = []
    weak var recipeDelegate: RecipeDelegate?
    private var recipe: [Recipe] = []
    private let viewModel = HomeViewModel()
    //  private let searchViewModel = SearchViewModel()
    private var fetchedRecipes: [Recipe] = []
    var isHomeCell: Bool = true
    private var categoryCollectionView = CategoryCollectionView()
    private let recipeCollectionView = RecipeCollectionView()
    
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search Recipes"
        searchBar.searchBarStyle = .default
        searchBar.layer.cornerRadius = 8
        searchBar.layer.masksToBounds = true
        searchBar.tintColor = UIColor.secondaryLabel
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Trending Now 🔥"
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.viewDidLoad()
        setupSearchBar()
        recipeCollectionView.dataSource = self
        recipeCollectionView.delegate = self
        categoryCollectionView.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchResults(_:)), name: Notification.Name("SearchResultsFetched"), object: nil)
        
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
        tableView.isHidden = true
    }
    
    // MARK: - Private Methods
    
    private func setupBackground() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func setupSearchBar() {
        searchBar.delegate = self
        navigationItem.titleView = searchBar
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
        //  mainStackView.addArrangedSubview(searchContainerView)
        mainStackView.addArrangedSubview(searchBar)
        mainStackView.addArrangedSubview(tableView)
        mainStackView.addArrangedSubview(categoryCollectionView)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(recipeCollectionView)
    }
    
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(recipeTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 170),
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: categoryCollectionView.bottomAnchor, constant: 10),
            titleStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            recipeCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
            recipeCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            recipeCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            recipeCollectionView.bottomAnchor.constraint(equalTo: mainStackView.bottomAnchor)
        ])
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    // MARK: - Notifications
    @objc func handleSearchResults(_ notification: Notification) {
        if let searchResults = notification.object as? [SearchData] {
            
            self.updateUIWithSearchResults(searchResults)
        }
    }
    func updateUIWithSearchResults(_ searchResults: [SearchData]) {
        
    }
}

// MARK: - RecipeDelegate
extension HomeViewController: RecipeDelegate {
    func passSelectedRecipesToProfileVC(selectedRecipes: [Recipe]) {
        let profileVC = ProfileViewController()
        profileVC.selectedRecipes = selectedRecipes
        profileVC.recipeDelegate = self
        print("HomeViewController is the delegate.")
        navigationController?.pushViewController(profileVC, animated: true)
    }
    func didSelectRecipe(recipe: Recipe) {
        let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: nil)
        let detailWrapper = RecipeDetailView(viewModel: detailViewModel)
        
        let hostingController = UIHostingController(rootView: detailWrapper)
        navigationController?.pushViewController(hostingController, animated: true)
    }
}

// MARK: - CollectionView DataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Number of items: \(recipe.count)")
        return recipe.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RecipeItemCell", for: indexPath) as? RecipeItemCollectionViewCell else {
            print("Error: Unable to dequeue RecipeItemCollectionViewCell.")
            
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
            
            let width = Int((collectionView.bounds.width - totalSpace) / 2)
            let height = 170
            
            return CGSize(width: width, height: height)
        }
    }
}


// MARK: - RecipeListViewModelDelegate

extension HomeViewController: RecipeListViewModelDelegate {
    func recipesFetched(_ recipe: [Recipe]) {
        print("Recipes fetched:", recipe)
        self.recipe = recipe
        DispatchQueue.main.async {
            self.recipeCollectionView.reloadData()
        }
    }
    
    func recipeFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    }
}


// MARK: - RecipeItemCollectionViewCellDelegate

extension HomeViewController: RecipeItemCollectionViewCellDelegate {
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell) {
        if let selectedRecipe = cell.recipe {
            print("Selected Recipe: \(selectedRecipe.title)")
            let detailViewModel = RecipeDetailViewModel(recipe: selectedRecipe, selectedIngredient: selectedRecipe.extendedIngredients?.first)
            let detailWrapper = RecipeDetailViewWrapper(viewModel: detailViewModel)
            let hostingController = UIHostingController(rootView: detailWrapper)
            navigationController?.pushViewController(hostingController, animated: true)
        }
    }
    
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell) {
        guard let indexPath = recipeCollectionView.indexPath(for: cell) else { return }
        let recipe = self.recipe[indexPath.item]
        
        if cell.favoriteButton.isSelected {
            favoriteRecipeModel.favoriteNewRecipes(recipe)
            selectedRecipes.append(recipe)
        } else {
            favoriteRecipeModel.deleteFavoriteRecipe(recipe)
            selectedRecipes = selectedRecipes.filter { $0.id != recipe.id }
        }
        
        recipeCollectionView.reloadItems(at: [indexPath])
        recipeDelegate?.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
        
        if let delegate = recipeDelegate {
            print("Recipes selected in HomeViewController: \(selectedRecipes)")
            delegate.passSelectedRecipesToProfileVC(selectedRecipes: selectedRecipes)
        } else {
            print("Recipe delegate is nil.")
            
        }
    }
}
// MARK: - UISearchBarDelegate

extension HomeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            //   searchViewModel.searchRecipes(for: searchText)
            tableView.isHidden = false
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        tableView.isHidden = searchText.isEmpty
    }
}
