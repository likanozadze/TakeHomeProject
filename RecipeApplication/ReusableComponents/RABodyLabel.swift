//
//  RABodyLabel.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

class RABodyLabel: UILabel {

    // MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(title: String, textColor: UIColor, textAlignment: NSTextAlignment, fontSize: CGFloat, weight: UIFont.Weight) {
        super.init(frame: .zero)
        self.text = title
        self.textAlignment = textAlignment
        self.textColor = textColor
        self.font = UIFont.systemFont(ofSize: fontSize, weight: weight)
        configure()
    }
    
    // MARK: - Configuration
    
    private func configure() {
     //   textColor = .secondaryLabel
        //font = UIFont.preferredFont(forTextStyle: .body)
        //adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.75
        lineBreakMode = .byWordWrapping
        translatesAutoresizingMaskIntoConstraints = false
    }
}
