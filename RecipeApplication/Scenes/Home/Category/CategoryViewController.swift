//
//  ShoppingListViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class CategoryViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    
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
        label.textColor = UIColor.secondaryTextColor
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        return stackView
    }()
    
    private var categoryCollectionView = CategoryCollectionView()
    var isHomeCell: Bool = true
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupTitleStackView()
        setupConstraints()
        
        categoryCollectionView.delegate = self
        categoryCollectionView.showsVerticalScrollIndicator = true
        categoryCollectionView.alwaysBounceVertical = true  
        
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
        mainStackView.addArrangedSubview(categoryCollectionView)
    }
    
    private func setupTitleStackView() {
        titleStackView.addArrangedSubview(mainTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleStackView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            categoryCollectionView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor),
            categoryCollectionView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            categoryCollectionView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -10),
        ])
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension CategoryViewController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfColumns: CGFloat = 2
        let spacing: CGFloat = 10
        
        let totalSpacing = (numberOfColumns - 1) * spacing
        let cellWidth = (collectionView.bounds.width - totalSpacing) / numberOfColumns
        
        let cellHeight: CGFloat = isHomeCell ? 100 : 240
        return CGSize(width: cellWidth, height: cellHeight)
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
        
        cell.isHomeCell = false
        cell.configure(with: categoryData[indexPath.row])
        
        return cell
    }
}
