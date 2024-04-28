//
//  RecipeSearchBar.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 4/26/24.
//

import UIKit

protocol RecipeSearchBarDelegate: AnyObject {
    func didChangeSearchQuery(_ query: String?)
}

final class RecipeSearchBar: UISearchBar, UISearchBarDelegate {
    
    // MARK: - Properties
    
    weak var searchDelegate: RecipeSearchBarDelegate?
    private var searchTimer: Timer?
    
    // MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addDelegate()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        placeholder = "Search for recipe"
        delegate = self
        showsBookmarkButton = true
        setImage(UIImage(systemName: "line.horizontal.3.decrease"), for: .bookmark, state: .normal)
        backgroundImage = UIImage() 
    }
    
    private func addDelegate() {
        self.delegate = self
    }

    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        searchTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            self?.searchDelegate?.didChangeSearchQuery(searchText)
        }
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchDelegate?.didChangeSearchQuery(searchBar.text)
    }
}
