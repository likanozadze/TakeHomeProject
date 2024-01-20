//
//  RATextField.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

class RATextField: UITextField {
    
    // MARK: - Enumeration for Text Field Type
    
    enum RATextFieldType {
        case username
        case email
        case password
    }
    
    // MARK: - Properties
    
    private let authoricationFieldType: RATextFieldType
    
    // MARK: - Initialization
    
    init(fieldType: RATextFieldType) {
        self.authoricationFieldType = fieldType
        super.init(frame: .zero)

        self.backgroundColor = .white
        self.layer.borderColor = UIColor.accentTextColor.cgColor
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        
        self.returnKeyType = .done
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        
        self.leftViewMode = .always
        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        

        switch fieldType {
        case .username:
            self.placeholder = "Username"
        case .email:
            self.placeholder = "Email Address"
            self.keyboardType = .emailAddress
            self.textContentType = .emailAddress
            
        case .password:
            self.placeholder = "Password"
            self.textContentType = .oneTimeCode
            self.isSecureTextEntry = true
        }
    }
    
    // MARK: - Required Initializer
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
