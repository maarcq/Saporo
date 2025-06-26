//
//  RecipeDetailViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import Foundation
import Combine

class RecipeDetailViewModel: ObservableObject {
    @Published var recipe: RecipeInformation?
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = true
    @Published var isFavorite: Bool = false

    private let recipeId: Int
    private let apiClient: SpoonacularAPIClient
    private let favoritesManager: FavoritesManager
    private var favoriteCancellable: AnyCancellable?

    init(recipeId: Int, apiClient: SpoonacularAPIClient = SpoonacularAPIClient(), favoritesManager: FavoritesManager = .shared) {
        self.recipeId = recipeId
        self.apiClient = apiClient
        self.favoritesManager = favoritesManager

        favoriteCancellable = favoritesManager.$favoriteRecipeIDs
            .sink { [weak self] favoriteIDs in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.isFavorite = favoriteIDs.contains(self.recipeId)
                }
            }
    }

    @MainActor
    func loadRecipeDetails() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedRecipe = try await apiClient.getRecipeInformation(id: recipeId)
            self.recipe = fetchedRecipe
            self.isFavorite = favoritesManager.isFavorite(recipeID: recipeId)

            print("Receita carregada para ID \(recipeId): \(fetchedRecipe.title)")
            if let instructions = fetchedRecipe.analyzedInstructions {
                print("Analyzed Instructions count: \(instructions.count)")
                if let firstSet = instructions.first {
                    print("First instruction set steps count: \(firstSet.steps.count)")
                }
            } else {
                print("Analyzed Instructions are NIL for this recipe.")
            }

        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
    
    func toggleFavorite() {
        if isFavorite {
            favoritesManager.removeFavorite(recipeID: recipeId)
        } else {
            favoritesManager.addFavorite(recipeID: recipeId)
        }
    }

    func stripHTML(from text: String) -> String {
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
                   .replacingOccurrences(of: "&nbsp;", with: " ")
                   .replacingOccurrences(of: "&amp;", with: "&")
                   .replacingOccurrences(of: "&quot;", with: "\"")
                   .replacingOccurrences(of: "&#39;", with: "'")
                   .replacingOccurrences(of: "&lt;", with: "<")
                   .replacingOccurrences(of: "&gt;", with: ">")
    }
}
