//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class HomeViewController: UIViewController {
    
    // MARK: - UI Components
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "What would you"
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
    }()
    
    private let subMainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Like to Cook?"
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        return label
    }()

    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.text = "Popular Recipes"
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        return label
    }()

    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
       stackView.distribution = .fillProportionally
        return stackView
    }()
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 16
        layout.itemSize = CGSize(width: 280, height: 240)
        
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
        setupConstraints()
        setupCollectionView()
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
        mainStackView.addArrangedSubview(titleStackView)
    
    }
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(mainTitleLabel)
        titleStackView.addArrangedSubview(subMainTitleLabel)
        titleStackView.addArrangedSubview(recipeTitle)
        
    }
    private func setupConstraints() {
        setupCollectionView()
       
    }
    
    private func setupCollectionView() {
        view.addSubview(mainStackView)
        view.addSubview(collectionView)
    
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: -30),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
            
        ])

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 300)
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
        let width = collectionView.bounds.width - flowLayout.minimumInteritemSpacing
           let height = collectionView.bounds.height
           return CGSize(width: 280, height: 240)
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
