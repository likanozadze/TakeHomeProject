//
//  RecipeItemCollectionViewCell.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/24/24.
//

//import UIKit
//import NetworkLayer
//
//class RecipeItemCollectionViewCell: UICollectionViewCell {
//    var networkManager: NetworkManager?
//    
//    // MARK: - Properties
//    private let recipeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.contentMode = .scaleAspectFill
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = UIColor.black
//        label.numberOfLines = 0
//        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
//        return label
//    }()
//    private let readyInMinLabel: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.textColor = .black
//        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
//        return label
//    }()
//    
//    
//    private let favoriteButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.tintColor = .red
//        button.setImage(UIImage(systemName: "heart"), for: .normal)
//      //  button.setImage(UIImage(systemName: "heart.fill"), for: .selected)
//      //  button.addTarget(target, action: #selector(keyPressed(_:)), for: .touchUpInside)
//       
//        return button
//    }()
//    
//    private lazy var bottomStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [readyInMinLabel, favoriteButton])
//        stackView.axis = .horizontal
//        stackView.spacing = 2
//        stackView.distribution = .fill
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        
//        return stackView
//    }()
//    
//    // MARK: - Init
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - CellLifeCycle
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        recipeImageView.image = nil
//        titleLabel.text = nil
//        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
//    }
//    // MARK: - Private Methods
//    private func addSubview() {
//        contentView.addSubview(recipeImageView)
//        contentView.addSubview(titleLabel)
//        contentView.addSubview(bottomStackView)
//    }
//    private func setupConstraints() {
//        
//        NSLayoutConstraint.activate([
//            recipeImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            recipeImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            recipeImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            recipeImageView.heightAnchor.constraint(equalToConstant: 230)
//        ])
//        
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
//            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
//        ])
//        NSLayoutConstraint.activate([
//            bottomStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
//            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
//            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
//        ])
//        
//    }
//        
//        private func setupButtonAction() {
//            favoriteButton.addAction(
//                UIAction(
//                    title: "",
//                    handler: { [weak self] _ in
//                        let isFavorite = self?.favoriteButton.currentImage == UIImage(systemName: "heart.fill")
//                        self?.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart" : "heart.fill"), for: .normal)
//                    }
//                ),
//                for: .touchUpInside
//            )
//        }
//    
//    // MARK: - Configuration
//    func convertToSecureURL(_ url: String) -> String {
//        return url.replacingOccurrences(of: "http://", with: "https://")
//    }
//
//    func configure(with recipe: Recipe) {
//        networkManager = NetworkManager.shared
//        
//        titleLabel.text = recipe.title
//        setImage(from: convertToSecureURL(recipe.sourceUrl ?? ""))
//        if let readyInMinutes = recipe.readyInMinutes {
//            readyInMinLabel.text = "\(readyInMinutes) min"
//        } else {
//            readyInMinLabel.text = "N/A"
//        }
//        
//    }
//    private func setImage(from url: String) {
//        guard let networkManager = networkManager else {
//            print("Network manager not set in RecipeItemCollectionViewCell.")
//            return
//        }
//        if url.isEmpty {
//            self.recipeImageView.image = UIImage(named: "placeholderImage")
//            return
//        }
//        
//        networkManager.downloadImage(from: url) { (result: Result<UIImage, NetworkError>) in
//            switch result {
//            case .success(let image):
//                DispatchQueue.main.async {
//                    self.recipeImageView.image = image
//                }
//            case .failure(let error):
//                print("Error downloading image: \(error)")
//                DispatchQueue.main.async {
//                    self.recipeImageView.image = UIImage(named: "placeholderImage")
//                }
//            }
//        }
//    }
//}
import UIKit

class RecipeItemCollectionViewCell: UICollectionViewCell {
    // MARK: - Properties
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
        setupButtonAction()
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
        favoriteButton.setImage(UIImage(systemName: "heart"), for: .normal)
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
            recipeTitle.topAnchor.constraint(equalTo: recipeImageView.bottomAnchor, constant: 8),
            recipeTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            recipeTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])

        NSLayoutConstraint.activate([
            bottomStackView.topAnchor.constraint(equalTo: recipeTitle.bottomAnchor, constant: 8),
            bottomStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            bottomStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            bottomStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    private func setupButtonAction() {
        favoriteButton.addAction(
            UIAction(
                title: "",
                handler: { [weak self] _ in
                    let isFavorite = self?.favoriteButton.currentImage == UIImage(systemName: "heart.fill")
                    self?.favoriteButton.setImage(UIImage(systemName: isFavorite ? "heart" : "heart.fill"), for: .normal)
                }
            ),
            for: .touchUpInside
        )
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
             readyInMinLabel.text = "\(readyInMinutes) min"
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
