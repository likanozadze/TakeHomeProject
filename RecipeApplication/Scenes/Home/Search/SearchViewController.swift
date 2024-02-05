////
////  SearchViewController.swift
////  RecipeApplication
////
////  Created by Lika Nozadze on 1/27/24.
////
//
//import UIKit
//
//class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, SearchViewModelDelegate {
//
//    var recipes: [SearchData] = [] {
//        didSet {
//            tableView.reloadData()
//        }
//    }
//    public let searchViewModel = SearchViewModel()
//    
//    private let tableView: UITableView = {
//        let tableView = UITableView()
//        tableView.translatesAutoresizingMaskIntoConstraints = false
//        return tableView
//    }()
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        setupUI()
//        searchViewModel.delegate = self
//    }
//    
//    private func setupUI() {
//        
//        view.addSubview(tableView)
//        
//        NSLayoutConstraint.activate([
//            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
//            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        ])
//        
//        tableView.dataSource = self
//        tableView.delegate = self
//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RecipeCell")
//        
//        if let searchController = navigationItem.searchController {
//            searchController.searchBar.delegate = self
//        }
//    }
//    
//    // MARK: - UITableViewDataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return recipes.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! SearchViewControllerCell
//        
//        let searchData = recipes[indexPath.row].title
//        cell.configure(with: searchData)
//        
//        return cell
//    }
//    
//    
//    // MARK: - UITableViewDelegate
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//    
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//           if let searchText = searchBar.text, !searchText.isEmpty {
//               searchViewModel.searchRecipes(for: searchText)
//           }
//       }
//    
//    // MARK: - SearchViewModelDelegate
//    
//    func searchResultsFetched(_ recipes: [SearchData]) {
//        print("Delegate method called with recipes:", recipes)
//        
//        DispatchQueue.main.async { [weak self] in
//            self?.recipes = recipes
//            self?.tableView.reloadData()
//            NotificationCenter.default.post(name: Notification.Name("SearchResultsFetched"), object: recipes)
//
//        }
//    }
//    
//    func searchError(_ error: Error) {
//    
//        print("Search error:", error)
//        DispatchQueue.main.async { [weak self] in
//            self?.tableView.reloadData()
//        }
//    }
//    
//    func searchStarted() {
//        print("Search started")
//        DispatchQueue.main.async { [weak self] in
//          
//        }
//    }
//}
