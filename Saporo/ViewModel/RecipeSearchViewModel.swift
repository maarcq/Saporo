//
//  RecipeSearchViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import Foundation
import Combine

class RecipeSearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    private let apiClient: SpoonacularAPIClient
    
    init(apiClient: SpoonacularAPIClient = SpoonacularAPIClient()) {
        self.apiClient = apiClient
    }
    
    @MainActor
    func searchRecipes() async {
        isLoading = true
        errorMessage = nil
        recipes = []
        
        do {
            let response = try await apiClient.searchRecipes(query: searchText)
            recipes = response.results
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
