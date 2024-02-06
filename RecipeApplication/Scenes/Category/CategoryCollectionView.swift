//
//  CategoryCollectionView.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/27/24.
//

import UIKit

final class CategoryCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {


    private let categoryCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: "CategoryCell")
              
        return collectionView
    }()
    
    // MARK: - Initialization

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let customLayout = UICollectionViewFlowLayout()
        customLayout.scrollDirection = .horizontal
        super.init(frame: frame, collectionViewLayout: customLayout)
        backgroundColor = .clear
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

    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: categoryData[indexPath.row])
        return cell
    }


    // MARK: - CollectionView FlowLayoutDelegate

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
