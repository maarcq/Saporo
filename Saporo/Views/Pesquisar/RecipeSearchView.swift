//
//  RecipeSearchView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import SwiftUI
import TipKit

struct FavoriteLandmarkTip: Tip {
    var title: Text {
        Text("Pesquise uma receita")
    }
}

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
                TextField("Search a recipe", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
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
                .padding(.top, 30)
            }
            if viewModel.isLoading {
                ProgressView("Searching recipes...")
                
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
            }
        }
        .background {
            BackgroundGeral()
        }
        .sheet(item: $selectedRecipe, content: { recipe in
            RecipeQuickDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
        })
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
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = RecipeSearchViewModel() // This viewModel will handle the fetching for this specific list
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    var body: some View {
        Group { // Use Group to handle conditional views easily
            if viewModel.isLoading {
                ProgressView("Loading recipes for \(cuisine)...")
            } else if let errorMessage = viewModel.errorMessage {
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else if viewModel.fetchedRecipes.isEmpty {
                Text("No recipe found for\(cuisine).")
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
                .sheet(item: $selectedRecipe, content: { recipe in
                    RecipeQuickDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
                })
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
