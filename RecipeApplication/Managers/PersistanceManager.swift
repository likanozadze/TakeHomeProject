//
//  PersistanceManager.swift
//  RecipeApplication
//
//  Created by Lika Nozadze on 2/10/24.
//

import Foundation

enum PersistenceActionType {
    case add, remove
}

enum PersistenceManager {
    
    static private let defaults = UserDefaults.standard
    
    enum Keys {
        static let favorites = "favorites"
    }
    
    static func updateWith(favorite: Recipe, actionType: PersistenceActionType, completed: @escaping (RAError?) -> Void) {
        print("Updating favorite: \(favorite.title), ActionType: \(actionType)")
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                
                switch actionType {
                case .add:
                    guard !favorites.contains(where: { $0.id == favorite.id }) else {
                        completed(.alreadyInFavorites)
                        return
                    }
                    favorites.append(favorite)
                case .remove:
                    favorites.removeAll { $0.id == favorite.id }
                }
                print("Favorites after update: \(favorites)")
                completed(save(favorites: favorites))
                
            case .failure(let error):
                completed(error)
            }
        }
    }
    
    static func retrieveFavorites(completed: @escaping (Result<[Recipe], RAError>) -> Void) {
        guard let favoritesData = defaults.object(forKey: Keys.favorites) as? Data else {
            completed(.success([]))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let favorites = try decoder.decode([Recipe].self, from: favoritesData)
            print("Favorites retrieved: \(favorites)")
            completed(.success(favorites))
        } catch {
            completed(.failure(.unableToFavorite))
        }
    }
    
    static func save(favorites: [Recipe]) -> RAError? {
        
        do {
            let encoder = JSONEncoder()
            let encodedFavorites = try encoder.encode(favorites)
            
            defaults.set(encodedFavorites, forKey: Keys.favorites)
            
            if let savedData = defaults.object(forKey: Keys.favorites) as? Data {
                let decoder = JSONDecoder()
                let savedFavorites = try decoder.decode([Recipe].self, from: savedData)
                print("Favorites saved: \(savedFavorites)")
            }
            return nil
        } catch {
            return .unableToFavorite
        }
    }
    
    static func toggleFavorite(recipe: Recipe, completed: @escaping (Result<Bool, RAError>) -> Void) {
        retrieveFavorites { result in
            switch result {
            case .success(var favorites):
                let isCurrentlyFavorited = favorites.contains(where: { $0.id == recipe.id })
                if isCurrentlyFavorited {
                    favorites.removeAll(where: {$0.id == recipe.id})
                } else {
                    favorites.append(recipe)
                }
                completed(.success(!isCurrentlyFavorited)) 
            case .failure(let error):
                completed(.failure(error))
            }
        }
    }
}
