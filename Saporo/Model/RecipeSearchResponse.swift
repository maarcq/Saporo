//
//  RecipeSearchResponse.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import Foundation

struct RecipeSearchResponse: Decodable {
    let results: [Recipe]
    let offset: Int
    let number: Int
    let totalResults: Int
    
}

struct Recipe: Identifiable, Decodable, Hashable {
    let id: Int
    let title: String
    let image: String?
    let imageType: String?
    let readyInMinutes: Int?
    let servings: Int?
    let cuisine: String?
}

struct RecipeByIngredients: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String
}

struct RecipeInformation: Decodable, Identifiable {
    let id: Int
    let title: String
    let image: String?
    let summary: String?
    let instructions: String?
    let readyInMinutes: Int?
    let servings: Int?
    let sourceUrl: String?
    
    
    struct AnalyzedInstruction: Decodable, Identifiable, Hashable {
        let name: String?
        let steps: [InstructionStep]
        
        var id: String { name ?? UUID().uuidString }
    }
    
    struct InstructionStep: Decodable, Identifiable, Hashable {
        let number: Int
        let step: String
        var id: Int { number }
    }
    
    let analyzedInstructions: [AnalyzedInstruction]?
}

struct Ingredient: Identifiable, Decodable, Hashable {
    let id: Int
    let name: String
    let image: String?
    var imageUrl: URL? {
        if let image = image {
            return URL(string: "https://spoonacular.com/cdn/ingredients_100x100/\(image)")
        }
        return nil
    }
}
