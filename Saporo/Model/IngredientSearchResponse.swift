//
//  IngridientSearchResponse.swift
//  ipadOS
//
//  Created by Raynara Coelho on 13/06/25.
//
import Foundation


struct IngredientSearchResponse: Decodable {
    let results: [Ingredient]
    let offset: Int
    let number: Int
    let totalResults: Int
}

struct PantryIngredient: Identifiable, Hashable, Codable { // Added Codable for easier storage (e.g., UserDefaults, Core Data)
    let id: Int // Spoonacular ID
    let name: String
    let image: String? // Optional image name from Spoonacular
    var quantity: Double // The amount the user has selected
    var unit: String
}
//ainda não sei se será necessário

// struct ExtendedIngredient: Decodable, Identifiable {
//    let id: Int?
//    let name: String
//    let amount: Double
//    let unit: String
//    
//    // ... outros campos como original, meta, measures
//    var uuid: UUID { UUID() } // Para Identifiable se id for opcional ou não único
// }
// let extendedIngredients: [ExtendedIngredient]?
