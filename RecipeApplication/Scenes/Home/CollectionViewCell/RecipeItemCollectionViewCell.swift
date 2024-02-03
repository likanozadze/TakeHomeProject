//
//  RecipeItemCollectionViewCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//

import UIKit

protocol RecipeItemCollectionViewCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: RecipeItemCollectionViewCell)
    
}

class RecipeItemCollectionViewCell: UICollectionViewCell {
    
    var recipe: Recipe?
    weak var delegate: RecipeItemCollectionViewCellDelegate?
    var favoriteRecipeModel = FavoriteRecipeModel()
    private let recipeCollectionView = RecipeCollectionView()
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
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
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

        button.addTarget(target, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
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
            recipeImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.7)

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
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        print("Heart button tapped.")
        sender.isSelected.toggle()
        delegate?.didTapFavoriteButton(on: self)
        
      //  guard let recipe = recipe else { return }
        
//        if sender.isSelected {
//            print("Heart button was selected. Now deselecting and removing the recipe from favorites.")
//            favoriteRecipeModel.deleteFavoriteRecipe(recipe)
//            DispatchQueue.main.async {
//                self.recipeCollectionView.reloadData()
//            }
//        } else {
//            print("Heart button was not selected. Now selecting and favoriting the recipe.")
//            favoriteRecipeModel.favoriteNewRecipes(recipe)
//            DispatchQueue.main.async {
//                self.recipeCollectionView.reloadData()
//                let indexPath = IndexPath(row: self.favoriteRecipeModel.getFavoriteRecipeList().count - 1, section: 0)
//                self.recipeCollectionView.scrollToItem(at: indexPath, at: .right, animated: true)
//            }
//        }
        
//        if let recipeID = recipe.id {
//            favoriteRecipeModel.setFavoriteButtonImage(button: sender, recipeID: recipeID)
        
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
    
    // MARK: - Configuration
    func convertToSecureURL(_ url: String?) -> String? {
        guard let url = url else {
            return nil
        }
        return url.replacingOccurrences(of: "http://", with: "https://")
    }
    
    func configure(with recipe: Recipe) {
        recipeTitle.text = recipe.title
    
        
        if let imageUrl = convertToSecureURL(recipe.image) {
            downloadImage(from: imageUrl)
        } else {
            recipeImageView.image = UIImage(named: "placeholderImage")
        }
        
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

