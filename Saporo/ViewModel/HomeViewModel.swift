//
//  HomeViewModel.swift
//  ipadOS
//
//  Created by Natanael nogueira on 13/06/25.
//

import Foundation

@Observable
class HomeViewModel {
    var appleRecipes: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    var eggWhitesRecipes: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    var breadRecipes: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    
    
    var errorMenssage: String?
    let SpApiClient: SpoonacularAPIClient
    
    init(SpApiClient: SpoonacularAPIClient = SpoonacularAPIClient()) {
        self.SpApiClient = SpApiClient
    }
    
    func fetchRecipesByIngredients() async {
        errorMenssage = nil
        do {
            appleRecipes = try await SpApiClient.getRecipeByQuery(query: "apple", number: 3)
//            eggWhitesRecipes = try await SpApiClient.getRecipeByQuery(query: "pasta", number: 5)
//            breadRecipes = try await SpApiClient.getRecipeByQuery(query:"bread", number: 5)
        } catch {
            errorMenssage = error.localizedDescription
        }
    }
}
