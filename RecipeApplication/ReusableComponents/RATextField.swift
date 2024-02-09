////
////  RATextField.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/19/24.
////
//
//import UIKit
//
//class RATextField: UITextField {
//    
//    // MARK: - Enumeration for Text Field Type
//    
//    enum RATextFieldType {
//        case username
//        case email
//        case password
//    }
//    
//    // MARK: - Properties
//    
//    private let authoricationFieldType: RATextFieldType
//    
//    // MARK: - Initialization
//    
//    init(fieldType: RATextFieldType) {
//        self.authoricationFieldType = fieldType
//        super.init(frame: .zero)
//
//        self.backgroundColor = .white
//        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 1
//        
//        self.returnKeyType = .done
//        self.autocorrectionType = .no
//        self.autocapitalizationType = .none
//        
//        self.leftViewMode = .always
//        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
//
//
//        
//        switch fieldType {
//        case .username:
//            self.placeholder = "Username"
//        case .email:
//            self.placeholder = "Email Address"
//            self.keyboardType = .emailAddress
//            self.textContentType = .emailAddress
//            
//        case .password:
//            self.placeholder = "Password"
//            self.textContentType = .oneTimeCode
//            self.isSecureTextEntry = true
//        }
//    }
//    
//    // MARK: - Required Initializer
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//}
//import UIKit
//
//class RATextField: UITextField {
//    
//    // MARK: - Enumeration for Text Field Type
//    
//    enum RATextFieldType {
//        case username
//        case email
//        case password
//    }
//    
//    // MARK: - Properties
//    
//    private let authoricationFieldType: RATextFieldType
//    
//    // MARK: - Initialization
//    
//    init(fieldType: RATextFieldType) {
//        self.authoricationFieldType = fieldType
//        super.init(frame: .zero)
//        
//        setupUI()
//    }
//    
//    // MARK: - Required Initializer
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    // MARK: - Private Methods
//    
//    private func setupUI() {
//        self.backgroundColor = .white
//        self.layer.borderColor = UIColor(named: "AccentColor")?.cgColor
//        self.layer.cornerRadius = 10
//        self.layer.borderWidth = 1
//        
//        self.returnKeyType = .done
//        self.autocorrectionType = .no
//        self.autocapitalizationType = .none
//        
//        self.leftViewMode = .always
//        self.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: self.frame.size.height))
//        
//        switch authoricationFieldType {
//        case .username:
//            self.placeholder = "Username"
//        case .email:
//            self.placeholder = "Email Address"
//            self.keyboardType = .emailAddress
//            self.textContentType = .emailAddress
//            
//        case .password:
//            self.placeholder = "Password"
//            self.textContentType = .oneTimeCode
//            self.isSecureTextEntry = true
//        }
//    }
//    
//    // MARK: - Trait Collection Change
//    
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//        
//
//            if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//                if self.traitCollection.userInterfaceStyle == .dark {
//                    self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
//                    self.textColor = UIColor.black
//                } else {
//                    self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//                    self.textColor = UIColor.black
//                }
//            }
//        }
//    }
//
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
