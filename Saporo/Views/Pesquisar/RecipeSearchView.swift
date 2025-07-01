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
    
    // New state variables for sheet presentation
    @State private var showingSheet: Bool = false
    @State private var selectedRecipeId: Int? // To store the ID of the recipe selected for the sheet
    
    // NOVO: Adicionado para controlar o foco do TextField
    @FocusState private var isSearchFieldFocused: Bool

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
                .focused($isSearchFieldFocused) // NOVO: Conecta o TextField ao FocusState

            if viewModel.isLoading {
                ProgressView("Buscando receitas...")

            } else if let errorMessage = viewModel.errorMessage {

                Text("Erro: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()

            } else {
                List {
                    ForEach(viewModel.recipes) { recipe in
                        Button {
                            self.selectedRecipeId = recipe.id
                            self.showingSheet = true
                        } label: {
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

        
       
        .onReceive(NotificationCenter.default.publisher(for: .SearchByVoice)) { _ in
            isSearchFieldFocused = true
        }
    }
}

#Preview {
    RecipeSearchView(navigationPath: .constant(NavigationPath()))
}
