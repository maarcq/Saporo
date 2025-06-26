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

    var body: some View {
        
        VStack {
            TextField("Pesquise uma receita", text: $viewModel.searchText)
                .textFieldStyle(.roundedBorder)
                .padding()
                .onSubmit {
                    Task {
                        await viewModel.searchRecipes()
                    }
                }
            
            if viewModel.isLoading {
                ProgressView("Buscando receitas...")
                
            } else if let errorMessage = viewModel.errorMessage {
                
                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
                
            } else {
                List {
                    ForEach(viewModel.recipes) { recipe in
                        NavigationLink(value: recipe) {
                            HStack {
                                if let imageUrl = recipe.image, let url = URL(string: imageUrl) {
                                    AsyncImage(url: url) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 50, height: 50)
                                            .cornerRadius(8)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 50, height: 50)
                                    }
                                }
                                
                                Text(recipe.title)
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
        .background {
            BackgroundGeral()
        }
    }
}

#Preview {
    RecipeSearchView(navigationPath: .constant(NavigationPath()))
}
