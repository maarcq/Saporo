//
//  RecipeSearchViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//


import Foundation
import Combine


struct CulinaryCategory: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
}

class RecipeSearchViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var cuisine: String = ""
    @Published var recipes: [Recipe] = []
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var fetchedRecipes: [Recipe] = []
    @Published var selectedCuisine: String? = nil
    @Published var staticCulinaryCategories: [CulinaryCategory] = [
        CulinaryCategory(name: "Italian", imageName: "italiana"),
        CulinaryCategory(name: "Japanese", imageName: "japonesa"),
        CulinaryCategory(name: "Mexican", imageName: "mexicana"),
        CulinaryCategory(name: "French", imageName: "francesa"),
        CulinaryCategory(name: "Chinese", imageName: "chinesa"),
        CulinaryCategory(name: "British", imageName: "britanica"),
        CulinaryCategory(name: "Spanish", imageName: "espanhola"),
        CulinaryCategory(name: "Indian", imageName: "indiana"),
        CulinaryCategory(name: "Korean", imageName: "coreana"),
        CulinaryCategory(name: "Greek", imageName: "grega"),
        CulinaryCategory(name: "Thai", imageName: "tailandesa"),
        CulinaryCategory(name: "Vietnamese", imageName: "vietnamita"),
        CulinaryCategory(name: "American", imageName: "americana"),
        CulinaryCategory(name: "Irish", imageName: "irlandesa"),
        CulinaryCategory(name: "African", imageName: "africana"),
        CulinaryCategory(name: "Caribbean", imageName: "caribenha")
    ]
    
    // NOVO: Propriedade para controlar o foco do campo de texto
    @Published var shouldFocusSearchField: Bool = false
    
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
    
    
    @MainActor
        func loadRecipesForCuisine(_ cuisine: String) async {
            isLoading = true
            errorMessage = nil
            selectedCuisine = cuisine
            fetchedRecipes = [] // Clear previous cuisine-specific recipes
            
            do {
                // Pass nil for query to get all recipes for the specific cuisine
                let response = try await apiClient.searchRecipes(query: nil, cuisine: cuisine)
                fetchedRecipes = response.results
            } catch {
                errorMessage = error.localizedDescription
            }
            
            isLoading = false
        }
}

