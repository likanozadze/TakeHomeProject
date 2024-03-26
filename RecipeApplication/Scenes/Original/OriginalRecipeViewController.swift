//
//  OriginalRecipeViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/21/24.
//


import UIKit
import SwiftUI
import FirebaseAuth
import Lottie

final class OriginalRecipeViewController: UIViewController {
    
    let viewModel = OriginalRecipeViewModel()
    @Published var originalRecipes: [OriginalRecipesData] = []
    var recipe: OriginalRecipesData?
    
    private let yourRecipesTitle: UILabel = {
        let label = UILabel()
        label.text = "Your Recipes"
        label.textColor = .testColorSet
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    private lazy var collectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return collectionView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [yourRecipesTitle, collectionView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = .black
        button.backgroundColor = .white
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        button.layer.masksToBounds = false
        button.layer.shadowRadius = 2.0
        button.layer.shadowOpacity = 0.5
        return button
    }()
    private let animationView = LottieAnimationView()

    let emptyStateViewController = EmptyStateViewController(
        title: "Save your original recipes", description: "Save the recipes that inspire you. Tap the plus to save them here", animationName: "Animation - 1711457021878")
    
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setup()
        updateEmptyStateVisibility()
        Task {
            await self.getRecipes()
        }
        
    }
    private func updateEmptyStateVisibility() {
        if originalRecipes.isEmpty {
            showEmptyState()
        } else {
            hideEmptyState()
        }
    }
    
    // MARK: - UI Setup
    
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
        setupCollectionView()
        setupAddButton()
    }
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviewsToView() {
        
        view.addSubview(mainStackView)
        view.addSubview(addButton)
        
    }
    
    //MARK: - Setup Collection View
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        registerCollectionViewCell()
    }
    private func registerCollectionViewCell() {
        collectionView.register(OriginalRecipeCell.self, forCellWithReuseIdentifier: "originalRecipeCell")
    }
    func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            mainStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        
        ])
    }
    
    private func showEmptyState() {
        if children.contains(emptyStateViewController) { return }
        
        addChild(emptyStateViewController)
        view.addSubview(emptyStateViewController.view)
        emptyStateViewController.view.frame = view.bounds
        emptyStateViewController.didMove(toParent: self)
        animationView.play()
        }

    
    private func hideEmptyState() {
        if children.contains(emptyStateViewController) {
            emptyStateViewController.willMove(toParent: nil)
            emptyStateViewController.view.removeFromSuperview()
            emptyStateViewController.removeFromParent()
        }
            animationView.stop()
        }
    
    
    //MARK: - action
    
    private func setupAddButton() {
        addButton.addAction(UIAction(handler: { [self] _ in
            addButtonTapped()
        }), for: .touchUpInside)
    }
    
    //MARK: - get Recipes
    
    private func getRecipes() async {
        await viewModel.getUserRecipes()
        originalRecipes = viewModel.originalRecipes
        collectionView.reloadData()
        updateEmptyStateVisibility()
    }
    private func addButtonTapped() {
        let viewController = UIHostingController(
            rootView: OriginalRecipeView(dismissAction: {
                Task {
                    await self.getRecipes()
                    self.dismiss(animated: true)
                }
            })
        )
        present(viewController, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension OriginalRecipeViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.originalRecipes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "originalRecipeCell", for: indexPath) as! OriginalRecipeCell
        
        let recipeData = viewModel.originalRecipes[indexPath.item]
        print("Recipe Data: \(recipeData)")
        cell.recipe = recipeData
        cell.delegate = self
        cell.configure(recipe: recipeData)
        print("Configuring cell with recipe: \(recipeData)")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let recipe = viewModel.originalRecipes[indexPath.item]
        didSelectRecipe(recipe: recipe)
    }
    
    // MARK: - CollectionView FlowLayoutDelegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 15
        let collectionViewWidth = collectionView.frame.width
        let itemWidth = (collectionViewWidth - spacing) / 2
        return CGSize(width: itemWidth, height: 240)
    }
}

extension OriginalRecipeViewController: OriginalRecipeCellDelegate {
    func didSelectRecipe(recipe: OriginalRecipesData) {
        print("didSelectRecipe called with recipe: \(recipe.name)")
        let detailViewController = UIHostingController(rootView: OriginalRecipeDetailView(recipe: recipe))
        navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func removeRecipe(cell: OriginalRecipeCell, recipeId: String) {
        guard let indexPath = collectionView.indexPath(for: cell) else { return }
        viewModel.originalRecipes.remove(at: indexPath.item)
        collectionView.deleteItems(at: [indexPath])
    }
}
