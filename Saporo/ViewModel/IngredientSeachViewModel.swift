//
//  IngridientSeachViewMoedel.swift
//  ipadOS
//
//  Created by Raynara Coelho on 13/06/25.
//

import Foundation
import Combine

@MainActor
//View Model que gerencia a despensa
class IngredientSearchViewModel: ObservableObject {
    @Published var searchText: String = "" {
            // MARK: - Observador para searchText
            didSet {
                // Se o searchText ficar vazio, resete searchPerformed para false.
                // Isso garante que a mensagem "Aperte enter..." apareça novamente
                // quando o usuário limpa o campo de busca e começa a digitar algo novo.
                if searchText.isEmpty {
                    searchPerformed = false
                }
            }
        }
    @Published var searchResults: [Ingredient] = [] // Ingredientes da busca
    @Published var userPantry: [PantryIngredient] = [] // Ingredientes na despensa do usuário
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var searchPerformed: Bool = false
    
    private let apiClient: SpoonacularAPIClient // cliente de API
    private let userDefaultsKey = "userPantry" // Chave para UserDefaults
    
    init(apiClient: SpoonacularAPIClient = SpoonacularAPIClient()) {
        self.apiClient = apiClient
        loadPantry() // Carrega a despensa ao inicializar o ViewModel
    }
    
    // MARK: - Busca de Ingredientes
    func performSearch() {
        // Lógica da sua busca, por exemplo, chamada de API
        isLoading = true
        errorMessage = nil
        searchPerformed = true // Marca que a busca foi executada
        
        // Simule uma busca assíncrona
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.isLoading = false
        }
    }
    
    func searchIngredients() async {
        guard !searchText.isEmpty else {
            // Essas atualizações já serão no main thread por causa do @MainActor
            searchResults = [] // Limpa resultados se a busca estiver vazia
            searchPerformed = false // Reseta se a busca for limpada
            return
        }
        isLoading = true
        errorMessage = nil
        searchPerformed = true
        searchResults = []
        
        do {
            let response = try await apiClient.searchIngredients(query: searchText)
            // Restorna os ingredientes da despensa
            searchResults = response.results
        } catch {
            errorMessage = error.localizedDescription
            print("Erro na busca de ingredientes: \(error.localizedDescription)")
        }
        isLoading = false
    }
    // Gerenciamento da despensa
    // Função para adicionar ou atualizar a quantidade de um ingrediente na despensa
    func updatePantryItemQuantity(ingredientID: Int, name: String, image: String?, change: Double) {
        if let index = userPantry.firstIndex(where: { $0.id == ingredientID }) {
            // Se o item já existe na despensa, atualiza a quantidade
            let currentQuantity = userPantry[index].quantity
            let newQuantity = max(0, currentQuantity + change) // Garante que não seja negativo
            userPantry[index].quantity = newQuantity
            
            // Se a nova quantidade for 0, remova o item da despensa
            if newQuantity == 0 {
                userPantry.remove(at: index)
            }
        } else if change > 0 {
            // Se o item não existe e estamos adicionando (change > 0), cria um novo
            // O unit pode ser 'unidades', 'gramas', 'litros', etc. Você pode querer uma Picker aqui depois.
            let newPantryItem = PantryIngredient(
                id: ingredientID,
                name: name,
                image: image,
                quantity: change, // Começa com a quantidade adicionada
                unit: "unidade(s)" // Valor padrão. Considere adicionar uma forma de o usuário escolher a unidade.
            )
            userPantry.append(newPantryItem)
        }
        savePantry() // Salva a despensa após cada alteração
    }
    
    // Função para remover um item da despensa (usado com onDelete no List)
    func removePantryItem(at offsets: IndexSet) {
        userPantry.remove(atOffsets: offsets)
        savePantry() // Salva a despensa após remover
    }
    
    // Persistência de Dados (UserDefaults)
    
    private func savePantry() {
        if let encoded = try? JSONEncoder().encode(userPantry) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("Despensa salva: \(userPantry.count) itens") // Debug
        } else {
            print("Erro ao codificar despensa para salvar.") // Debug
        }
    }
    
    private func loadPantry() {
        if let savedPantryData = UserDefaults.standard.data(forKey: userDefaultsKey) {
            if let decodedPantry = try? JSONDecoder().decode([PantryIngredient].self, from: savedPantryData) {
                userPantry = decodedPantry
                print("Despensa carregada: \(userPantry.count) itens") // Debug
            } else {
                print("Erro ao decodificar despensa carregada.") // Debug
            }
        } else {
            print("Nenhum dado de despensa encontrado em UserDefaults.") // Debug
        }
    }
    
}


//Antiga View Model dos ingredientes
//class IngredientSearchViewModel: ObservableObject {
//    @Published var searchText: String = ""
//    @Published var ingredient: [Ingredient] = []
//    @Published var errorMessage: String? = nil
//    @Published var isLoading: Bool = false
//
//    @Published var searchResults: [PantryIngredient] = []
//    @Published var userPantry: [PantryIngredient] = []
//
//    private let apiClient: SpoonacularAPIClient
//
//    init(apiClient: SpoonacularAPIClient = SpoonacularAPIClient()) {
//        self.apiClient = apiClient
//    }
//
//    @MainActor
//    func searchIngredients() async {
//        isLoading = true
//        errorMessage = nil
//        ingredient = []
//        searchResults = []
//
//        do {
//            let response = try await apiClient.searchIngredients(query: searchText)
//            //ingredient = response.results
//            searchResults = response.results.map { spoonacularIngredient in
//                // You might want to fetch more detailed info (like possibleUnits) here
//                // using the /information endpoint if needed, but for now,
//                // let's default to 'item' or 'each' as a starting unit.
//                PantryIngredient(
//                    id: spoonacularIngredient.id,
//                    name: spoonacularIngredient.name,
//                    image: spoonacularIngredient.image,
//                    quantity: 0.0, // Start with 0, user will add
//                    unit: "item" // A sensible default unit
//                )
//            }
//        } catch {
//            errorMessage = error.localizedDescription
//        }
//        isLoading = false
//
//
//    }
//    // New: Function to update the quantity of an ingredient in the searchResults
//    func updateIngredientQuantity(ingredientID: Int, change: Double) {
//        if let index = searchResults.firstIndex(where: { $0.id == ingredientID }) {
//            let currentQuantity = searchResults[index].quantity
//            let newQuantity = max(0, currentQuantity + change) // Ensure quantity doesn't go below 0
//            searchResults[index].quantity = newQuantity
//        }
//    }
//
//    // New: Function to add an ingredient from searchResults to the user's pantry
//    func addIngredientToPantry(_ ingredient: PantryIngredient) {
//        // Prevent adding duplicates. If it exists, update its quantity.
//        if let index = userPantry.firstIndex(where: { $0.id == ingredient.id }) {
//            userPantry[index].quantity += ingredient.quantity // Add to existing quantity
//            // You might want a more sophisticated merge if units differ
//        } else {
//            userPantry.append(ingredient)
//        }
//        // Optional: Remove from searchResults if it's considered "added"
//        // Or keep it in searchResults if users might add multiple times.
//    }
//
//    // New: Function to remove an ingredient from the user's pantry
//    func removeIngredientFromPantry(ingredientID: Int) {
//        userPantry.removeAll(where: { $0.id == ingredientID })
//    }
//}
