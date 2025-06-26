//
//  FavoritesManager.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 13/06/25.
//


import Foundation
import Combine

class FavoritesManager: ObservableObject {
    static let shared = FavoritesManager()

    private let favoritesKey = "favoriteRecipeIDs"

    @Published var favoriteRecipeIDs: Set<Int> {
        didSet {
            saveFavorites()
        }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: favoritesKey) {
            if let decodedIDs = try? JSONDecoder().decode(Set<Int>.self, from: data) {
                self.favoriteRecipeIDs = decodedIDs
                return
            }
        }
        self.favoriteRecipeIDs = []
    }

    func addFavorite(recipeID: Int) {
        objectWillChange.send()
        favoriteRecipeIDs.insert(recipeID)
    }

    func removeFavorite(recipeID: Int) {
        objectWillChange.send()
        favoriteRecipeIDs.remove(recipeID)
    }

    func isFavorite(recipeID: Int) -> Bool {
        return favoriteRecipeIDs.contains(recipeID)
    }

    private func saveFavorites() {
        if let encoded = try? JSONEncoder().encode(favoriteRecipeIDs) {
            UserDefaults.standard.set(encoded, forKey: favoritesKey)
        }
    }
}
