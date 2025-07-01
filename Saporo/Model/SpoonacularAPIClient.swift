//
//  SpoonacularAPIClient.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import Foundation

class SpoonacularAPIClient {
    //f9b66f8c2a2244649fcf4842a537d3f8 Natan
    //f0104e6af6864ac090e9ece49d34af22 Raynara
    //c206d846f25f40558f2036aa4806bc81 Bernado
    private let apiKey: String = "f9b66f8c2a2244649fcf4842a537d3f8"
    private let baseURL: String = "https://api.spoonacular.com/"
    
    enum APIError: Error, LocalizedError {
        case invalidURL
        case networkError(Error)
        case decodingError(Error)
        case apiError(String)
        
        var errorDescription: String? {
            switch self {
            case .invalidURL: return "URL inválida."
            case .networkError(let error): return "Erro de rede: \(error.localizedDescription)"
            case .decodingError(let error): return "Erro ao decodificar dados: \(error.localizedDescription)"
            case .apiError(let message): return "Erro da API: \(message)"
            }
        }
    }
    
    func searchRecipes(query: String, number: Int = 20) async throws -> RecipeSearchResponse {
        guard var components = URLComponents(string: baseURL + "recipes/complexSearch") else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "number", value: String(number))
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                throw APIError.apiError("Erro de status HTTP: \(statusCode). Resposta: \(responseString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(RecipeSearchResponse.self, from: data)
            return result
        } catch let decodingError as DecodingError {
            print("DEBUG: Decoding Error in searchRecipes: \(decodingError)")
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func getRecipeInformation(id: Int) async throws -> RecipeInformation {
        guard var components = URLComponents(string: baseURL + "recipes/\(id)/information") else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "addRecipeInformation", value: "true"),
            URLQueryItem(name: "includeNutrition", value: "false")
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                throw APIError.apiError("Erro de status HTTP ao buscar detalhes: \(statusCode). Resposta: \(responseString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(RecipeInformation.self, from: data)
            return result
        } catch let decodingError as DecodingError {
            print("DEBUG: Decoding Error for RecipeInformation (ID: \(id)): \(decodingError)")
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func searchIngredients(query: String, number: Int = 20) async throws -> IngredientSearchResponse {
        guard var components = URLComponents(string: baseURL + "food/ingredients/search") else {
            throw APIError.invalidURL
        }
        components.queryItems = [
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "number", value: String(number))
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                let responseString = String(data: data, encoding: .utf8) ?? "No response data"
                throw APIError.apiError("Erro de status HTTP: \(statusCode). Resposta: \(responseString)")
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(IngredientSearchResponse.self, from: data)
            return result
        } catch let decodingError as DecodingError {
            print("DEBUG: Decoding Error in searchRecipes: \(decodingError)")
            throw APIError.decodingError(decodingError)
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func getRecipeByIngredients(ingredients: [String], number: Int) async throws -> [RecipeByIngredients] {
        guard var components = URLComponents(string: baseURL + "recipes/findByIngredients") else {
            throw APIError.invalidURL
        }
        
        let ingredientsString = ingredients.joined(separator: ",")
        
        components.queryItems = [
            URLQueryItem(name: "ingredients", value: ingredientsString),
            URLQueryItem(name: "number", value: String(number)),
            URLQueryItem(name: "apiKey", value: apiKey)
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try check(data: data, response: response)
            let recipeByIngredients = try JSONDecoder().decode([RecipeByIngredients].self, from: data)
            return recipeByIngredients
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func getRecipeByQuery(query: String, number: Int) async throws -> RecipeSearchResponse {
        guard var components = URLComponents(string: baseURL + "recipes/complexSearch") else {
            throw APIError.invalidURL
        }
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "number", value: String(number)),
            URLQueryItem(name: "apiKey", value: apiKey),
            URLQueryItem(name: "instructionsRequired", value: "true"),
            URLQueryItem(name: "addRecipeInformation", value: "true")
        ]
        
        guard let url = components.url else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            try check(data: data, response: response) 
            let recipeByQuery = try JSONDecoder().decode(RecipeSearchResponse.self, from: data)
            return recipeByQuery
        } catch {
            throw APIError.networkError(error)
        }
    }
    
    func check(data: Data?, response: URLResponse) throws {
        if let response = response as? HTTPURLResponse {
            switch response.statusCode {
            case 200..<300:
                print("😸 Sucesso! \(response.statusCode)")
            default:
                print("🙀 Erro \(response.statusCode)")
                throw APIErro.apiError(code: response.statusCode, body: data)
            }
        }
    }
    
    enum APIErro: Error {
        case apiError(code: Int, body: Data?)
    }
    
    //    func getIngredientsInformation(id: Int) async throws -> IngredientInformation {
    //        guard var components = URLComponents(string: baseURL + "food/ingredients/\(id)/information") else {
    //            throw APIError.invalidURL
    //        }
    //
    //        components.queryItems = [
    //            URLQueryItem(name: "apiKey", value: apiKey),
    //            URLQueryItem(name: "addIngredientInformation", value: "true"),
    //            URLQueryItem(name: "includeNutrition", value: "false")
    //        ]
    //
    //        guard let url = components.url else {
    //            throw APIError.invalidURL
    //        }
    //
    //        do {
    //            let (data, response) = try await URLSession.shared.data(from: url)
    //
    //            guard let httpResponse = response as? HTTPURLResponse,
    //                  (200...299).contains(httpResponse.statusCode) else {
    //                let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
    //                let responseString = String(data: data, encoding: .utf8) ?? "No response data"
    //                throw APIError.apiError("Erro de status HTTP ao buscar detalhes: \(statusCode). Resposta: \(responseString)")
    //            }
    //
    //            let decoder = JSONDecoder()
    //            decoder.keyDecodingStrategy = .convertFromSnakeCase
    //
    //            let result = try decoder.decode(IngredientInformation.self, from: data)
    //            return result
    //        } catch let decodingError as DecodingError {
    //            print("DEBUG: Decoding Error for RecipeInformation (ID: \(id)): \(decodingError)")
    //            throw APIError.decodingError(decodingError)
    //        } catch {
    //            throw APIError.networkError(error)
    //        }
    //    }
}
