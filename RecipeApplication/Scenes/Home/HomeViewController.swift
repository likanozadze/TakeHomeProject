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
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    // MARK: - Private Methods
    
    private func setup() {
        view.backgroundColor = UIColor.backgroundColor
    }
    
}
