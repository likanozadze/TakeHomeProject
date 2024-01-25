//
//  ViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class HomeViewController: UIViewController {

    
    
    // MARK: - Properties

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 16
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        
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
        setupNavigationBar()
        setupCollectionView()
    }
    // MARK: - Private Methods
    
    private func setupBackground() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
    private func setupNavigationBar() {

    }
    private func setupCollectionView() {
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        collectionView.register(RecipeItemCollectionViewCell.self, forCellWithReuseIdentifier: "RecipeItemCell")
        collectionView.dataSource = self
        collectionView.delegate = self
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
