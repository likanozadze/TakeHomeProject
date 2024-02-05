////
////  SearchViewControllerCell.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/27/24.
////
//
//import UIKit
//
//class SearchViewControllerCell: UITableViewCell {
//
//    let titleLabel: UILabel = {
//        let titleLabel = UILabel()
//        titleLabel.translatesAutoresizingMaskIntoConstraints = false
//        return titleLabel
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        
//        addSubview(titleLabel)
//        
//        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
//        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
//        titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    func configure(with recipeTitle: String) {
//            titleLabel.text = recipeTitle
//        }
//}
