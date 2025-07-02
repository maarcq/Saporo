//
//  RecipeSearchView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import SwiftUI

struct RecipeSearchView: View {
    @State private var showingSheet: Bool = false
    @State private var selectedRecipe: Recipe?
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = RecipeSearchViewModel()
    //@StateObject private var viewModelFavorite = FavoritesViewModel()
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    // New state variables for sheet presentation
    @State private var selectedRecipeId: Int? // To store the ID of the recipe selected for the sheet
    
    // NOVO: Adicionado para controlar o foco do TextField
    @FocusState private var isSearchFieldFocused: Bool
    
    var body: some View {
        
        VStack {
            HStack{
                TextField("Pesquise uma receita", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                //                    .padding(.top, 60)
                //                    .padding(.leading, 8)
                //                    .padding(.trailing, 8)
                    .onSubmit {
                        Task {
                            await viewModel.searchRecipes()
                        }
                    }
                
                if !viewModel.searchText.isEmpty {
                    Button(action: {
                        viewModel.searchText = ""
                        viewModel.recipes = [] // Limpa resultados ao cancelar
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.top, 80)
            .padding(.leading, 8)
            .padding(.trailing, 8)
            
            if viewModel.searchText.isEmpty {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 60) {
                            ForEach(viewModel.staticCulinaryCategories) { cuisine in
                                Button{
                                    navigationPath.append(Destination.recipeList(cuisine:cuisine.name))
                                } label: {
                                    HomeItensView(
                                        image: cuisine.imageName,
                                        nameRecipe: cuisine.name,
                                        maxReadyTime: nil
                                    )
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    .containerRelativeFrame([.horizontal, .vertical])
                    .navigationDestination(for: String.self) { cuisine in
                        RecipeListView(navigationPath: $navigationPath, cuisine: cuisine)
                    }
                }
                .padding(.top, 30)
            }
            
            if viewModel.isLoading {
                ProgressView("Buscando receitas...")
                
            } else if let errorMessage = viewModel.errorMessage {
                
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                
            } else {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 60) {
                            ForEach(viewModel.recipes) { recipe in
                                Button{
                                    self.selectedRecipe = recipe
                                    self.showingSheet = true
                                } label: {
                                    HomeItensView(
                                        image: recipe.image!,
                                        nameRecipe: recipe.title,
                                        maxReadyTime: nil
                                    )
                                }
                                
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                    .navigationDestination(for: Recipe.self) { recipe in
                        RecipeDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
                    }
                }
                
            }
        }
        .background {
            BackgroundGeral()
        }
        .sheet(isPresented: $showingSheet) {
            if let selectedrecipe = selectedRecipe {
                RecipeQuickDetailView(recipeId: selectedrecipe.id, navigationPath: $navigationPath)
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .SearchByVoice)) { _ in
            isSearchFieldFocused = true
        }
    }
}

#Preview {
    RecipeSearchView(navigationPath: .constant(NavigationPath()))
}

struct RecipeListView: View {
    @State private var showingSheet: Bool = false
    @State private var selectedRecipe: Recipe?
    
    let cuisine: String
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    var body: some View {
        // Use Group to handle conditional views easily
        Group {
            if viewModel.isLoading {
                ProgressView("Carregando receitas de \(cuisine)...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.fetchedRecipes.isEmpty {
                Text("Nenhuma receita encontrada para \(cuisine).")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                VStack{
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 60) {
                            ForEach(viewModel.fetchedRecipes) { recipe in // Display fetchedRecipes here
                                Button{
                                    self.selectedRecipe = recipe
                                    self.showingSheet = true
                                } label: {
                                    HomeItensView(
                                        image: recipe.image!,
                                        nameRecipe: recipe.title,
                                        maxReadyTime: nil
                                    )
                                }
                            }
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .sheet(isPresented: $showingSheet) {
                    if let selectedrecipe = selectedRecipe {
                        RecipeQuickDetailView(recipeId: selectedrecipe.id, navigationPath: $navigationPath)
                    }
                }
            }
        }
        .background {
            BackgroundGeral()
        }
        .navigationTitle(cuisine)
        .onAppear {
            Task {
                // Call loadRecipesForCuisine with the correct cuisine
                await viewModel.loadRecipesForCuisine(cuisine)
                print("Fetched recipes for cuisine: \(cuisine)")
            }
        }
    }
}
