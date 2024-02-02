//
//  FavoriteRecipeCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/2/24.
//

import UIKit

final class FavoriteRecipeCell: UICollectionViewCell {
    
    var recipe: Recipe?
    
    // MARK: - UI Components
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor.black
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        return label
    }()
    private let readyInMinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    internal let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [readyInMinLabel, favoriteButton])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //    private lazy var favoriteStackView: UIStackView = {
    //        let stackView = UIStackView(arrangedSubviews: [recipeImageView, recipeTitle])
    //        stackView.axis = .vertical
    //        stackView.spacing = 5
    //        stackView.distribution = .fill
    //        stackView.translatesAutoresizingMaskIntoConstraints = false
    //        return stackView
    //    }()
    
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
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
        recipeTitle.text = nil
        readyInMinLabel.text = nil
    }
    
    
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(recipeTitle)
        contentView.addSubview(bottomStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 180)
            
        ])
        
        NSLayoutConstraint.activate([
            recipeTitle.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 10),
            recipeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: 8),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
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
    
    func configure(with recipe: Recipe) {
        self.recipe = recipe
        
        if let imageUrl = recipe.image {
            if let url = URL(string: imageUrl) {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let data = data, error == nil {
                        DispatchQueue.main.async {
                            self.recipeImageView.image = UIImage(data: data)
                        }
                    }
                }.resume()
            }
        }
        
        recipeTitle.text = recipe.title
        
        if let readyInMinutes = recipe.readyInMinutes {
            let attachment = NSTextAttachment()
            attachment.image = UIImage(systemName: "clock")?.withTintColor(UIColor.accentTextColor)
            let attachmentString = NSAttributedString(attachment: attachment)
            let myString = NSMutableAttributedString(string: "\(readyInMinutes) min ")
            myString.insert(attachmentString, at: 0)
            readyInMinLabel.attributedText = myString
        } else {
            readyInMinLabel.text = "N/A"
        }
    }
}
