//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit
import SwiftUI

final class HomeViewController: UIViewController, UISearchBarDelegate {
    
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
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 16
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    private var recipe: [Recipe] = []
    private let viewModel = HomeViewModel()
    private let searchViewModel = SearchViewModel()
    private var fetchedRecipes: [Recipe] = []
    var isHomeCell: Bool = true
    private var categoryCollectionView = CategoryCollectionView()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.fetchRecipes()
        setupSearchBar()
        NotificationCenter.default.addObserver(self, selector: #selector(handleSearchResults(_:)), name: Notification.Name("SearchResultsFetched"), object: nil)
     
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
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text, !searchText.isEmpty {
            searchViewModel.searchRecipes(for: searchText)
            tableView.isHidden = false
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        tableView.isHidden = searchText.isEmpty
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
        mainStackView.addArrangedSubview(collectionView)
}

    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(recipeTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: categoryCollectionView.topAnchor, constant: -10)
        ])

        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 10),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            categoryCollectionView.heightAnchor.constraint(equalToConstant: 150),
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
        
        collectionView.register(RecipeItemCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
    }
    @objc func handleSearchResults(_ notification: Notification) {
        if let searchResults = notification.object as? [SearchData] {
          
            self.updateUIWithSearchResults(searchResults)
        }
    }
    func updateUIWithSearchResults(_ searchResults: [SearchData]) {
      
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
        cell.configure(with: recipe[indexPath.row])
        return cell
        
    }
}
// MARK: - CollectionView FlowLayoutDelegate
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = (collectionView.bounds.width - totalSpace) / 2
        let height = width * 1.5
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - CollectionView Delegate
extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let recipe = viewModel.recipe(at: indexPath) {
            let detailViewModel = RecipeDetailViewModel(recipe: recipe, selectedIngredient: recipe.extendedIngredients?[indexPath.row])
            let detailWrapper = RecipeDetailViewWrapper(viewModel: detailViewModel)

            let hostingController = UIHostingController(rootView: detailWrapper)
            navigationController?.pushViewController(hostingController, animated: true)
        }
    }
}


// MARK: - RecipeListViewModelDelegate
extension HomeViewController: RecipeListViewModelDelegate {
    func recipesFetched(_ recipe: [Recipe]) {
        print("Recipes fetched:", recipe)
        self.recipe = recipe
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func recipeFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    }
}
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.isHomeCell = true
        cell.configure(with: categoryData[indexPath.row])
        return cell
    }


