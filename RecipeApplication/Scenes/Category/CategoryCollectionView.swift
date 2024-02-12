//
//  CategoryCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/27/24.
//

import UIKit

// MARK: - CategoryCollectionView

final class CategoryCollectionView: UICollectionView {
    
    // MARK: - Properties
    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let customLayout = UICollectionViewFlowLayout()
        super.init(frame: frame, collectionViewLayout: customLayout)
        dataSource = self
        delegate = self
        register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Collection View
    
    private func setupCollectionView() {
        self.dataSource = self
        categoryCollectionView.delegate = self
    }
}
// MARK: - UICollectionViewDataSource

extension CategoryCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout

extension CategoryCollectionView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categoryData[indexPath.row])
        return cell
    }
}
