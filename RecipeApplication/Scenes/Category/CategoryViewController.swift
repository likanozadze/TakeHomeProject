//
//  ShoppingListViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class CategoryViewController: UIViewController {
    
    private var selectedCategory: String?
     var categoryViewModel = CategoryViewModel()
     var recipe: [Recipe] = []
    
    // MARK: - UI Components
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let mainTitle: UILabel = {
        let label = UILabel()
        label.text = "Categories"
        label.textColor = .testColorSet
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()

    
    private var categoryCollectionView = CategoryCollectionView()
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        categoryViewModel.delegate = self
        categoryViewModel.fetchRecipesByTag("")
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.showsVerticalScrollIndicator = true
        categoryCollectionView.alwaysBounceVertical = true  
        
        if let layout = categoryCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
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
        mainStackView.addArrangedSubview(categoryCollectionView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor)
        ])
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
        + flowLayout.sectionInset.right
        + flowLayout.minimumInteritemSpacing
        
        let width = (collectionView.bounds.width - totalSpace) / 2
        let height = width * 0.8
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - UICollectionViewDataSource
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            print("Error: Unable to dequeue CategoryCollectionViewCell.")
            return UICollectionViewCell()
        }
        
        cell.configure(with: categoryData[indexPath.row])
        
        return cell
    }
}
// MARK: - UICollectionViewDelegate
    extension CategoryViewController: UICollectionViewDelegate {
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            let selectedTag = categoryData[indexPath.row].title.lowercased()
            let categoryRecipeViewController = CategoryRecipeViewController()

           
            categoryRecipeViewController.selectedCategory = selectedTag
            categoryRecipeViewController.categoryViewModel.fetchRecipesByTag(selectedTag)
            categoryRecipeViewController.categoryViewModel.recipes = categoryViewModel.recipes
            navigationController?.pushViewController(categoryRecipeViewController, animated: true)
        }

    }

    extension CategoryViewController: CategoryListViewModelDelegate {
        func categoriesFetched(_ recipes: [Recipe]) {
            DispatchQueue.main.async {
                print("Recipes fetched successfully: \(recipes)")
            }
        
        }
        

        func categoryFetchError(_ error: Error) {
            DispatchQueue.main.async {
                print("Error fetching recipes: \(error.localizedDescription)")
            }
        }
    }
