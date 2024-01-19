//
//  RAButton.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

// MARK: - RAButton Class

class RAButton: UIButton {

// MARK: - Initialization

override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
}

required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
}

init(backgroundColor: UIColor, title: String, textColor: UIColor?) {
    super.init(frame: .zero)
    self.backgroundColor = backgroundColor
    self.setTitle(title, for: .normal)
    self.setTitleColor(textColor, for: .normal)
    configure()
}

// MARK: - Configuration

private func configure() {
    layer.cornerRadius = 10
    titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)
    translatesAutoresizingMaskIntoConstraints = false
}
}
