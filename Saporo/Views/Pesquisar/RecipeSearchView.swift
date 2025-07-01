//
//  RecipeSearchView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 12/06/25.
//

import SwiftUI

struct RecipeSearchView: View {

    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = RecipeSearchViewModel()
    //@StateObject private var viewModelFavorite = FavoritesViewModel()
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    @State private var showingSheet: Bool = false
    @State private var selectedRecipeId: Int?

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
                    //.padding(.trailing, 8)
                }
            }
            .padding(.top, 80)
            .padding(.leading, 8)
            .padding(.trailing, 8)
            if viewModel.searchText.isEmpty {
                NavigationStack {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 60) {
                            ForEach(viewModel.staticCulinaryCategories) { cuisine in
                                NavigationLink(value: cuisine.name) {
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
                        RecipeListView(cuisine: cuisine, navigationPath: $navigationPath)
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
                NavigationStack {
                    ScrollView(.vertical) {
                        LazyVGrid(columns: columns, spacing: 60) {
                            ForEach(viewModel.recipes) { recipe in
                                NavigationLink(value: recipe) {
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
            if let id = selectedRecipeId {
                RecipeQuickDetailView(recipeId: id, navigationPath: $navigationPath) 
            }
        }
    }
}

#Preview {
    RecipeSearchView(navigationPath: .constant(NavigationPath()))
}


struct RecipeListView: View {
    let cuisine: String
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = RecipeSearchViewModel() // This viewModel will handle the fetching for this specific list
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    var body: some View {
        Group { // Use Group to handle conditional views easily
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
                                NavigationLink(value: recipe) {
                                    HomeItensView(
                                        image: recipe.image!,
                                        nameRecipe: recipe.title,
                                        maxReadyTime: nil
                                    )
                                    //                            HStack {
                                    //                                if let url = URL(string: recipe.image ?? "") {
                                    //                                    AsyncImage(url: url) { image in
                                    //                                        image.resizable()
                                    //                                            .aspectRatio(contentMode: .fit)
                                    //                                            .frame(width: 50, height: 50)
                                    //                                            .cornerRadius(8)
                                    //                                    } placeholder: {
                                    //                                        ProgressView()
                                    //                                            .frame(width: 50, height: 50)
                                    //                                    }
                                    //                                }
                                    //                                Text(recipe.title)
                                    //                            }
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
