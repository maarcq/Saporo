//
//  FavoritesView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 11/06/25.
//

import SwiftUI

struct FavoritesView: View {
    
    @Binding var navigationPath: NavigationPath
    @StateObject private var viewModel = FavoritesViewModel()
    
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Carregando favoritos...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.favoriteRecipes.isEmpty {
                    Image("forkandKnife")
                    Text("Você ainda não favoritou nenhuma receita.\nFavorita alguma na tela de detalhes!")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    LazyVGrid(columns: columns, spacing: 60) {
                        ForEach(viewModel.favoriteRecipes) { recipe in
                            NavigationLink(value: recipe.id) {
                                HStack(alignment: .top) {
                                    HomeItensView(
                                        image: recipe.image!,
                                        nameRecipe: recipe.title,
                                        maxReadyTime: recipe.readyInMinutes!
                                    )
                                }
                            }
                            .contextMenu {
                                Button(role: .destructive) {
                                    viewModel.removeFavorite(recipeID: recipe.id)
                                } label: {
                                    Label("Remover dos Favoritos", systemImage: "star.slash.fill")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .navigationDestination(for: Int.self) { recipeId in
                        RecipeDetailView(recipeId: recipeId, navigationPath: $navigationPath)
                    }
                }
            }
        }
        .scrollDisabled(viewModel.favoriteRecipes.isEmpty)
        .containerRelativeFrame([.horizontal, .vertical])
        .padding(.top, 500)
        .background {
            BackgroundGeral()
        }
    }
}
//
//#Preview {
//    FavoritesView()
//}
