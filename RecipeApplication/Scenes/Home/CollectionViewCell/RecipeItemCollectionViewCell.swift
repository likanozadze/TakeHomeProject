//
//  RecipeItemCollectionViewCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//

import UIKit

// MARK: - RecipeItemCollectionViewCellDelegate

protocol RecipeItemCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell)
    func didSelectRecipe(on cell: RecipeItemCollectionViewCell)
}

// MARK: - RecipeItemCollectionViewCell
class RecipeItemCollectionViewCell: UICollectionViewCell {
    
    // MARK: Properties
    var recipe: Recipe?
    weak var delegate: RecipeItemCollectionViewCellDelegate?
    
    // MARK: - UI Components
    
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 10
        stackView.alignment = .top
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 12, left: 16, bottom: 12, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
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
        label.textColor = UIColor(named: "textColor")
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let dishLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "CustomGray")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private lazy var titleStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [recipeTitle, dishLabel])
        stackView.axis = .vertical
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let servingsLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "CustomGray")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let personSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "person")
        imageView.tintColor = UIColor(named: "CustomGray")
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let readyInMinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: "CustomGray")
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let clockSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "alarm")
        imageView.tintColor = UIColor(named: "CustomGray")
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var clockStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockSymbol, readyInMinLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    internal let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .red
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var servingsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [personSymbol, servingsLabel])
        stackView.axis = .horizontal
        stackView.spacing = 2
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bottomStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [clockStackView, servingsStackView])
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview()
        setupConstraints()
        configureCellAppearance()
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        
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
        servingsLabel.text = nil
        dishLabel.text = nil
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    // MARK: - Private Methods
    
    private func addSubview() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(recipeImageView)
        mainStackView.addArrangedSubview(bottomStackView)
        mainStackView.addArrangedSubview(titleStackView)
        contentView.addSubview(favoriteButton)
        
    }
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: contentView.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            favoriteButton.topAnchor.constraint(equalTo: mainStackView.topAnchor, constant: 16),
            favoriteButton.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -16),
            favoriteButton.widthAnchor.constraint(equalToConstant: 28),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
            
            
        ])
    }
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        guard let recipe = recipe else { return }
        
        sender.isSelected.toggle()
        
        let actionTypeDescription: String = sender.isSelected ? "add" : "remove"
        let actionType: PersistenceActionType = sender.isSelected ? .add : .remove
        
        PersistenceManager.updateWith(favorite: recipe, actionType: actionType) { error in
            if let error = error {
                print("Error \(actionTypeDescription) recipe: \(error.rawValue)")
            } else {
                PersistenceManager.retrieveFavorites { result in
                    switch result {
                    case .success(let favoriteRecipes):
                        print("Retrieved favorite recipes: \(favoriteRecipes)")
                    case .failure(let error):
                        print("Error retrieving favorites: \(error.rawValue)")
                    }
                }
            }
        }
        
        if sender.isSelected {
            delegate?.didTapFavoriteButton(on: self)
        }
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
    
    // MARK: - Configuration
    func convertToSecureURL(_ url: String?) -> String? {
        guard let url = url else {
            return nil
        }
        return url.replacingOccurrences(of: "http://", with: "https://")
    }
    
    func configure(with recipe: Recipe) {
        self.recipe = recipe
        recipeTitle.text = recipe.title
        
        
        if let imageUrl = convertToSecureURL(recipe.image) {
            downloadImage(from: imageUrl)
        } else {
            recipeImageView.image = UIImage(named: "")
        }
        if let readyInMinutes = recipe.readyInMinutes {
            readyInMinLabel.text = "\(readyInMinutes)min"
        } else {
            readyInMinLabel.text = "N/A"
        }
        
        if let servings = recipe.servings {
            servingsLabel.text = "\(servings)"
        } else {
            
            servingsLabel.text = "N/A"
        }
        
        
        if let dishTypesArray = recipe.dishTypes {
            dishLabel.text = dishTypesArray[0]
        }
        
    }
    private func downloadImage (from url: String?) {
        guard let urlString = url, let imageUrl = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.recipeImageView.image = UIImage(named: "placeholderImage")
            }
            return
        }
        
        URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
            guard let data = data, let image = UIImage(data: data) else {
                DispatchQueue.main.async {
                    self.recipeImageView.image = UIImage(named: "placeholderImage")
                }
                return
            }
            
            DispatchQueue.main.async {
                self.recipeImageView.image = image
            }
        }.resume()
        
    }
}
