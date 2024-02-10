////
////  SearchViewControllerCell.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/27/24.
////
////
//import UIKit
//
//class SearchViewControllerCell: UITableViewCell {
//
//    private let mainStackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.spacing = 8
//        stackView.isLayoutMarginsRelativeArrangement = true
//        stackView.layoutMargins = .init(top: 8, left: 16, bottom: 8, right: 16)
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        return stackView
//    }()
//
//    private let recipeImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.layer.cornerRadius = 8
//        imageView.contentMode = .scaleAspectFit
//        imageView.layer.masksToBounds = true
//        return imageView
//    }()
//    
//    private let recipeTitle: UILabel = {
//        let label = UILabel()
//        label.textAlignment = .left
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.textColor = UIColor(named: "textColor")
//        label.numberOfLines = 2
//        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
//        return label
//    }()
//    
//    var recipe: Recipe?
//    // MARK: - Init
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        selectionStyle = .none
//        addSubviews()
//        setupConstraints()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - PrepareForReuse
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        recipeImageView.image = nil
//        recipeTitle.text = nil
//    }
//    // MARK: - Configure
////    func configure(with recipe: Recipe) {
////        // Assuming recipe.image is a URL string
////        if let imageUrlString = recipe.image,
////           let imageUrl = URL(string: imageUrlString) {
////            // Perform image loading asynchronously
////            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
////                if let data = data {
////                    // Create UIImage from data and update UI on main thread
////                    DispatchQueue.main.async {
////                        self.recipeImageView.image = UIImage(data: data)
////                    }
////                }
////            }.resume()
////        }
////        recipeTitle.text = recipe.title
////    }
////
//    func configure(with searchData: SearchData) {
//        // Update cell UI based on SearchData
//        recipeTitle.text = searchData.title
//        // You might want to handle image loading if applicable
//    }
//    private func addSubviews() {
//        addSubview(mainStackView)
//        mainStackView.addArrangedSubview(recipeImageView)
//        mainStackView.addArrangedSubview(recipeTitle)
//    }
//    
//    private func setupConstraints() {
//        NSLayoutConstraint.activate([
//            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
//            mainStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
//            mainStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
//            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
//            
//            recipeImageView.widthAnchor.constraint(equalToConstant: 80),
//            recipeImageView.heightAnchor.constraint(equalToConstant: 80),
//        ])
//    }
//}
