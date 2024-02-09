//
//  LoginViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/20/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    private var viewModel = LoginViewModel()
    var coordinator: NavigationCoordinator?
    
    
    // MARK: - UI Components
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    
    private let headerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        return imageView
        
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Welcome to your"
        label.textColor = .testColorSet
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        return label
        
    }()
    
    private let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Good Recipes App"
        label.textColor = .testColorSet
        label.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let emailField = RATextField(fieldType: .email)
    
    private let passwordField = RATextField(fieldType: .password)
    
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private let signInButton = RAButton(title: "Sign In", hasBackground: true, fontSize: .medium)
    private let newUserButton = RAButton(title: "Don't have an account, Sign up", hasBackground: false, fontSize: .small)
    
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupBindings()
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        
    }
    
    // MARK: - UI Setup
    private func setup() {
        setupBackground()
        addSubviewsToView()
        setupConstraints()
    }
    
    private func setupBackground() {
        view.backgroundColor = .systemBackground
    }
    
    private func addSubviewsToView() {
        addMainSubviews()
        setupHeaderStackView()
        setupTextFieldStackView()
        setupButtonStackView()
    }
    
    private func addMainSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(headerStackView)
        mainStackView.addArrangedSubview(textFieldStackView)
        mainStackView.addArrangedSubview(buttonStackView)
        
    }
    
    private func setupHeaderStackView() {
        headerStackView.addArrangedSubview(logoImageView)
        headerStackView.addArrangedSubview(titleLabel)
        headerStackView.addArrangedSubview(subTitleLabel)
    }
    
    private func setupTextFieldStackView() {
        textFieldStackView.addArrangedSubview(emailField)
        textFieldStackView.addArrangedSubview(passwordField)
    }
    
    private func setupButtonStackView() {
        buttonStackView.addArrangedSubview(signInButton)
        buttonStackView.addArrangedSubview(newUserButton)
    }
    
    private func setupConstraints() {
        setupMainViewConstraints()
        setupHeaderStackViewConstraints()
        setupTextFieldConstraints()
        setupButtonConstraints()
    }
    
    private func setupMainViewConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            mainStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor)
        ])
    }
    
    private func setupHeaderStackViewConstraints() {
        NSLayoutConstraint.activate([
            logoImageView.heightAnchor.constraint(equalToConstant: 80),
            logoImageView.widthAnchor.constraint(equalToConstant: 80),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),
            subTitleLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    
    private func setupTextFieldConstraints() {
        NSLayoutConstraint.activate([
            emailField.heightAnchor.constraint(equalToConstant: 52),
            passwordField.heightAnchor.constraint(equalToConstant: 52)
            
        ])
    }
    
    private func setupButtonConstraints() {
        NSLayoutConstraint.activate([
            signInButton.heightAnchor.constraint(equalToConstant: 46),
            newUserButton.heightAnchor.constraint(equalToConstant: 46)
            
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
