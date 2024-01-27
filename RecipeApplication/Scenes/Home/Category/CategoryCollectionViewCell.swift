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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()


    // MARK: - Init
    
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
            categoryImageView.heightAnchor.constraint(equalToConstant: 180)
        ])

        NSLayoutConstraint.activate([
            categoryTitle.topAnchor.constraint(equalTo: categoryImageView.topAnchor, constant: 65),
            categoryTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            //categoryTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            categoryTitle.heightAnchor.constraint(equalToConstant: 30),
            categoryTitle.widthAnchor.constraint(equalToConstant: 160)
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
        }
    
    func configure(with data: CategoryData) {
            
            self.categoryTitle.text = data.title
            self.categoryImageView.image = data.image
        }
}
