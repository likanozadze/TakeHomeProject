//
//  ProfileViewController.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 1/18/24.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    var coordinator: NavigationCoordinator?
    
    // MARK: - UI Components
    private let logOutButton = RAButton(title: "log out", hasBackground: true, fontSize: .medium)
    
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.logOutButton.addTarget(self, action: #selector(didTapLogout), for: .touchUpInside)
    }
    
    
    // MARK: - UI Setup
    private func setupUI() {
        self.view.backgroundColor = .systemBackground
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(logOutButton)
        NSLayoutConstraint.activate([
            self.logOutButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.logOutButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
    }
    
    // MARK: - Selectors
    @objc private func didTapLogout() {
        AuthService.shared.signOut { [weak self] error in
            guard let self = self else { return }
            if let error = error {
                RAAlertView.showLogoutError(on: self, with: error)
                return
            }
            
            if let sceneDelegate = self.view.window?.windowScene?.delegate as? SceneDelegate {
                sceneDelegate.coordinator?.checkAuthentication()
            }
        }
    }
    
}
