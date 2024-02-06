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
    private let categoryTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12, weight: .semibold)
        return label
    }()
    
    var isHomeCell: Bool = true
    
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
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(categoryImageView)
        contentView.addSubview(categoryTitle)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        
        ])
        
        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: categoryImageView.bottomAnchor, constant: 5),
            categoryTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            
        ])
        
    }
    private func configureCellAppearance() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.masksToBounds = false
        contentView.layer.shadowColor = UIColor.gray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1, height: 2)
        contentView.layer.shadowOpacity = 0.2
        contentView.layer.shadowRadius = 8
        contentView.layer.shadowPath = UIBezierPath(roundedRect: contentView.bounds, cornerRadius: 8).cgPath
    
    }
    func configure(with data: CategoryData) {
        self.categoryTitle.text = data.title
        self.categoryImageView.image = data.image
        
        if isHomeCell {
            categoryImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
            categoryImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        } else {
            categoryImageView.heightAnchor.constraint(equalToConstant: 175).isActive = true
            categoryImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }
    
        self.categoryImageView.setNeedsLayout()
        self.categoryImageView.layoutIfNeeded()
    }
}
