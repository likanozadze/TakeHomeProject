//
//  RecipeItemCollectionViewCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//

import UIKit
import NetworkLayer

class RecipeItemCollectionViewCell: UICollectionViewCell {
    var networkManager: NetworkManager?
    
    // MARK: - Properties
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 8
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    private let readyInMinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()

    
    private let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
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

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - CellLifeCycle
    override func prepareForReuse() {
        super.prepareForReuse()
        
        recipeImageView.image = nil
        titleLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    // MARK: - Private Methods
    private func addSubview() {
        contentView.addSubview(recipeImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(bottomStackView)
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            recipeImageView.heightAnchor.constraint(equalToConstant: 230)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 20),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    // MARK: - Configuration
    func configure(with recipe: Recipe) {
        networkManager = NetworkManager.shared
        
        titleLabel.text = recipe.title
        setImage(from: recipe.sourceUrl ?? "")
        if let readyInMinutes = recipe.readyInMinutes {
               readyInMinLabel.text = "\(readyInMinutes) min"
           } else {
               readyInMinLabel.text = "N/A"
           }
           
        
    }
    private func setImage(from url: String) {
        guard let networkManager = networkManager else {
            print("Network manager not set in RecipeItemCollectionViewCell.")
            return
        }
        if url.isEmpty {
         
            self.recipeImageView.image = UIImage(named: "placeholderImage")
            return
        }
        
        networkManager.downloadImage(from: url) { (result: Result<UIImage, NetworkError>) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case .failure(let error):
                print("Error downloading image: \(error)")
                DispatchQueue.main.async {
                    self.recipeImageView.image = UIImage(named: "placeholderImage")
                }
            }
        }
    }
}
