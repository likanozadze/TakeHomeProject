//
//  OriginalRecipeCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 3/24/24.
//

import Foundation

import UIKit

protocol OriginalRecipeCellDelegate: AnyObject {
    func removeRecipe(cell: OriginalRecipeCell, recipeId: String)
    func didSelectRecipe(recipe: OriginalRecipesData) 
}

final class OriginalRecipeCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var viewModel = OriginalRecipeViewModel()
    weak var delegate: OriginalRecipeCellDelegate?
    var recipe: OriginalRecipesData?
    
    private let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 18
        view.layer.masksToBounds = true
        return view
    }()
    
    private let recipeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let recipeTitle: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .testColorSet
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    private let clockSymbol = {
        let imageView = UIImageView()
        imageView.image = .init(systemName: "clock")
        imageView.widthAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 14).isActive = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let readyInMinLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .testColorSet
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return label
    }()
    
    private let removeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.tintColor = .testColorSet
        button.addTarget(self, action: #selector(removeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    private lazy var clockStack = {
        let stackView = UIStackView(arrangedSubviews: [clockSymbol, readyInMinLabel])
        stackView.spacing = 5
        return stackView
    }()
    
    private lazy var titleStack = {
        let stackView = UIStackView(arrangedSubviews: [recipeTitle])
        stackView.alignment = .trailing
        stackView.axis = .horizontal
        
        stackView.distribution = .fill
        return stackView
    }()
    
    private lazy var mainStackView = {
        let stackView = UIStackView(arrangedSubviews: [recipeImageView, clockStack, titleStack])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .top
        stackView.spacing = 15
        return stackView
    }()
    
    
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
       
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
       
    }
    
    // MARK: - Prepare For Reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        recipeImageView.image = nil
        recipeTitle.text = nil
        readyInMinLabel.text = nil
        
    }
    
    // MARK: - Private Methods
    
    private func setupUI() {
        backgroundColor = .clear
        addViews()
        addConstraints()
        configureCellAppearance()
        
    }
    private func addViews() {
        contentView.addSubview(cellView)
        cellView.addSubview(mainStackView)
        contentView.addSubview(removeButton)
    }
    
    //MARK: - Add Constraints
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            cellView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cellView.centerYAnchor.constraint(equalTo: centerYAnchor),
            cellView.heightAnchor.constraint(equalToConstant: 220),
            
            recipeImageView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor),
            recipeImageView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor),
            recipeImageView.topAnchor.constraint(equalTo: mainStackView.topAnchor),
            
            
            mainStackView.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 10),
            mainStackView.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            mainStackView.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10),
            
            removeButton.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -10),
            removeButton.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10),
            removeButton.widthAnchor.constraint(equalToConstant: 20),
            removeButton.heightAnchor.constraint(equalToConstant: 20),
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
    
    @objc private func removeButtonTapped() {
        guard let recipe = recipe else {
            print("Recipe data not available for deletion")
            return
        }
        delegate?.removeRecipe(cell: self, recipeId: recipe.id)
    }
        
    func configure(recipe: OriginalRecipesData?) {
        guard let recipe = recipe else {
            print("Recipe is nil")
            return
        }
        
        recipeImageView.load(urlString: recipe.image)
        recipeTitle.text = recipe.name
        
        let hours = recipe.time / 60
        let minutes = recipe.time % 60
        
        if hours > 0 {
            if minutes > 0 {
                readyInMinLabel.text = "\(hours)hr \(minutes)min"
            } else {
                readyInMinLabel.text = "\(hours)hr"
            }
        } else {
            readyInMinLabel.text = "\(minutes)min"
        }
    
    }
}

var imageCache = NSCache<NSString, UIImage>()

extension UIImageView {
    func load(urlString: String) {
        print("URL to Load:", urlString) 
        if urlString == "image" {
            self.image = UIImage(named: "placeholderImage")
            return
        }

        guard URL(string: urlString) != nil else {
            print("Invalid URL: \(urlString)")
            return
        }

        URLSession.shared.invalidateAndCancel()
        
        if let url = URL(string: urlString) {
            let task = URLSession.shared.dataTask(with: url) { [weak self] (data, response, error) in
                guard let self = self else { return }
                if error != nil {
                    print("Failed to load image:", error?.localizedDescription ?? "")
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else { return }
                
                print("Image data received")
                imageCache.setObject(image, forKey: urlString as NSString)
                
                DispatchQueue.main.async {
                    self.image = image
                }
            }
            task.resume()
        }
    }
}
