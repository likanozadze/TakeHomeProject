//
//  CategoryCollectionViewCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/27/24.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell {
    // MARK: - UI Components
    
    private let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true

        return imageView
    }()
    
    private let arrowButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .testColorSet
        button.setImage(UIImage(systemName: "arrow.forward.circle.fill"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        configureCellAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        categoryImageView.image = nil
        arrowButton.setImage(UIImage(systemName:  "arrow.forward.circle.fill"), for: .normal)
    }
    
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(categoryImageView)
        contentView.addSubview(arrowButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            categoryImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 1)
            ])
        NSLayoutConstraint.activate([
            
        arrowButton.bottomAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: -18),
        arrowButton.trailingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: -12)
        ])
    }
    private func configureCellAppearance() {
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 8).cgPath
        
    }
    func configure(with data: CategoryData) {
        self.categoryImageView.image = data.image
        
    }
}
