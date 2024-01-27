//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI Components
//    
//    private let searchBar: UISearchBar = {
//        let searchBar = UISearchBar()
//        searchBar.placeholder = "Search Recipes"
//        searchBar.translatesAutoresizingMaskIntoConstraints = false
//        searchBar.searchBarStyle = .default
//        searchBar.layer.borderWidth = 0.2
//        searchBar.layer.cornerRadius = 8
//        searchBar.layer.masksToBounds = true
//        searchBar.backgroundColor = .white
//        searchBar.tintColor = UIColor.secondaryLabel
//        return searchBar
//    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular Recipes"
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        // stackView.spacing = 8
        stackView.alignment = .leading
        //  stackView.distribution = .fillProportionally
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
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupViewModelDelegate()
        viewModel.fetchRecipes()
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupTitleStackView()
     //   setupConstraintSearch()
        setupConstraints()
        
    }
    // MARK: - Private Methods
    
    private func setupBackground() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
    //    view.addSubview(searchBar)
        mainStackView.addArrangedSubview(titleStackView)
        mainStackView.addArrangedSubview(collectionView)
        
    }
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(recipeTitle)
    }
    
//    private func setupConstraintSearch() {
//        NSLayoutConstraint.activate([
//            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
//            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
//            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -60),
//            searchBar.heightAnchor.constraint(equalToConstant: 40)
//        ])
//    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
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
    }
    
    private func setupViewModelDelegate() {
        viewModel.delegate = self
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
        //viewModel.didSelectMovie(at: indexPath)
    }
}


// MARK: - RecipeListViewModelDelegate
extension HomeViewController: RecipeListViewModelDelegate {
    func recipesFetched(_ recipe: [Recipe]) {
        self.recipe = recipe
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
    func recipeFetchError(_ error: Error) {
        print("Error fetching recipes: \(error.localizedDescription)")
    }
}
