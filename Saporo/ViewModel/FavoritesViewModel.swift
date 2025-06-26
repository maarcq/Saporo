//
//  FavoritesViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 13/06/25.
//

import Foundation
import Combine

class FavoritesViewModel: ObservableObject {
    @Published var favoriteRecipes: [RecipeInformation] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let apiClient: SpoonacularAPIClient
    private let favoritesManager: FavoritesManager
    private var cancellables = Set<AnyCancellable>()
    init(apiClient: SpoonacularAPIClient = SpoonacularAPIClient(), favoritesManager: FavoritesManager = .shared) {
        self.apiClient = apiClient
        self.favoritesManager = favoritesManager
        
        favoritesManager.$favoriteRecipeIDs
            .sink { [weak self] newIDs in
                Task { @MainActor in
                    await self?.loadFavoriteRecipes(ids: newIDs)
                }
            }
            .store(in: &cancellables)
    }
    
    @MainActor
    func loadFavoriteRecipes(ids: Set<Int>) async {
        isLoading = true
        errorMessage = nil
        var fetchedRecipes: [RecipeInformation] = []
        
        guard !ids.isEmpty else {
            favoriteRecipes = []
            isLoading = false
            return
        }

        for id in ids {
            do {
                let recipe = try await apiClient.getRecipeInformation(id: id)
                fetchedRecipes.append(recipe)
            } catch {
                print("DEBUG: Erro ao carregar receita favorita com ID \(id): \(error.localizedDescription)")
                errorMessage = "Alguns favoritos não puderam ser carregados."
            }
        }
        
        favoriteRecipes = fetchedRecipes.sorted { $0.title < $1.title }
        isLoading = false
    }

    func removeFavorite(recipeID: Int) {
        favoritesManager.removeFavorite(recipeID: recipeID)
    }
}
