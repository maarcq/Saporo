//
//  HomeViewModel.swift
//  ipadOS
//
//  Created by Natanael nogueira on 13/06/25.
//

import Foundation

@Observable
class HomeViewModel {
    
    var saoJoao: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    var sobremesas: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    var breadRecipes: RecipeSearchResponse = RecipeSearchResponse(results: [], offset: 0, number: 0, totalResults: 0)
    var errorMenssage: String?
    let SpApiClient: SpoonacularAPIClient
    
    init(SpApiClient: SpoonacularAPIClient = SpoonacularAPIClient()) {
        self.SpApiClient = SpApiClient
    }
    
    func fetchRecipesByIngredients() async {
        errorMenssage = nil
        do {
            saoJoao = try await SpApiClient.getRecipeByQuery(query: "corn", number: 24)
            sobremesas = try await SpApiClient.getRecipeByQuery(query: "dessert", number: 24)
            breadRecipes = try await SpApiClient.getRecipeByQuery(query:"bread", number: 24)
        } catch {
            errorMenssage = error.localizedDescription
        }
    }
}
