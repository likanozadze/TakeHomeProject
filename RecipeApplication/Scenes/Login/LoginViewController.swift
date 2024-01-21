//
//  LoginViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    var coordinator: NavigationCoordinator?
    private var viewModel = LoginViewModel()
    
    // MARK: - UI Components
    private let headerView = RAHeaderView(title: "Welcome to your", subTitle: "Good Recipes App")
    private let emailField = RATextField(fieldType: .email)
    private let passwordField = RATextField(fieldType: .password)
    private let signInButton = RAButton(title: "Sign In", hasBackground: true, fontSize: .medium)
    private let newUserButton = RAButton(title: "Don't have an account, Sign up", hasBackground: false, fontSize: .small)
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        
        self.view.addSubview(headerView)
        self.view.addSubview(emailField)
        self.view.addSubview(passwordField)
        self.view.addSubview(signInButton)
        self.view.addSubview(newUserButton)
        
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        emailField.translatesAutoresizingMaskIntoConstraints = false
        passwordField.translatesAutoresizingMaskIntoConstraints = false
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        newUserButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalTo: self.view.layoutMarginsGuide.topAnchor),
            self.headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            self.headerView.widthAnchor.constraint(equalTo: self.view.widthAnchor, constant: -40),
            self.headerView.heightAnchor.constraint(equalToConstant: 222),
            
            self.emailField.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 12),
            self.emailField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.emailField.heightAnchor.constraint(equalToConstant: 55),
            self.emailField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.passwordField.topAnchor.constraint(equalTo: emailField.bottomAnchor, constant: 22),
            self.passwordField.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.passwordField.heightAnchor.constraint(equalToConstant: 55),
            self.passwordField.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.signInButton.topAnchor.constraint(equalTo: passwordField.bottomAnchor, constant: 22),
            self.signInButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.signInButton.heightAnchor.constraint(equalToConstant: 55),
            self.signInButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85),
            
            self.newUserButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 11),
            self.newUserButton.centerXAnchor.constraint(equalTo: headerView.centerXAnchor),
            self.newUserButton.heightAnchor.constraint(equalToConstant: 44),
            self.newUserButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85)
            
        ])
    }
    // MARK: - Action Handlers
    @objc private func didTapSignIn() {
        guard let email = emailField.text, let password = passwordField.text else {
            return
        }
        
        viewModel.signIn(email: email, password: password) { [weak self] (success: Bool, error: Error?) in
            guard let self = self else { return }
            if let error = error {
                RAAlertView.showSignInErrorAlert(on: self, with: error.localizedDescription)
            } else {
                self.coordinator?.checkAuthentication()
            }
        }
    }
    
    @objc private func didTapNewUser() {
        coordinator?.register()
    }
    
    // MARK: - Binding
    
    private func setupBindings() {
        signInButton.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        newUserButton.addTarget(self, action: #selector(didTapNewUser), for: .touchUpInside)
    }
}

// MARK: - LoginViewModelDelegate

extension LoginViewController: LoginViewModelDelegate {
    func showInvalidEmailAlert() {
        RAAlertView.showInvalidEmailAlert(on: self)
    }
    
    func showInvalidPasswordAlert() {
        RAAlertView.showInvalidPasswordAlert(on: self)
    }
    
    func showSignInErrorAlert(with error: String) {
        RAAlertView.showSignInErrorAlert(on: self, with: error)
    }
    
    func authenticationSuccessful() {
        coordinator?.checkAuthentication()
    }
}
