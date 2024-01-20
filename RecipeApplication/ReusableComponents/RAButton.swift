//
//  RAButton.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

class RAButton: UIButton {
    
    // MARK: - Font Size Enumeration
    
    enum FontSize {
        case small
        case medium
        case big
    }
    
    // MARK: - Initialization
    
    init(title: String, hasBackground: Bool = false, fontSize: FontSize) {
        super.init(frame: .zero)
        self.setTitle(title, for: .normal)
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        
        if hasBackground {
            self.backgroundColor = UIColor.secondaryButtonBackgroundColor
            self.setTitleColor(UIColor.primaryTextColor, for: .normal)
        } else {
            self.backgroundColor = UIColor.clear
            self.setTitleColor(UIColor.black, for: .normal)
        }
        
        switch fontSize {
        case .small:
            self.titleLabel?.font = .systemFont(ofSize: 16, weight: .regular)
        case .medium:
            self.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        case .big:
            self.titleLabel?.font = .systemFont(ofSize: 22, weight: .bold)
    
        }
    }
    
    // MARK: - Required Initializer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
