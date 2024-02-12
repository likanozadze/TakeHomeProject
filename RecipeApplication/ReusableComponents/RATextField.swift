//
//  RATextField.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/19/24.
//

import UIKit

class RATextField: UITextField {
    
    enum RATextFieldType {
        case username
        case email
        case password
    }
    
    private let authoricationFieldType: RATextFieldType
    
    init(fieldType: RATextFieldType) {
        self.authoricationFieldType = fieldType
        super.init(frame: .zero)
    translatesAutoresizingMaskIntoConstraints = false
        
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor =  UIColor(named: "AccentColor")?.cgColor

        textAlignment = .left
        adjustsFontSizeToFitWidth = true
        leftViewMode = .always
    leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
        
        backgroundColor = .secondarySystemBackground
        autocorrectionType = .no
        returnKeyType = .done
        clearButtonMode = .whileEditing
        autocapitalizationType = .none
        
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
