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
    @State private var selectedRecipe: RecipeInformation?
    
    let columns = [GridItem(.adaptive(minimum: 200), spacing: 16)]
    
    @State private var showingSheet: Bool = false
    @State private var selectedRecipeId: Int?
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading Favorites...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Erro: \(errorMessage)")
                        .foregroundColor(.red)
                        .padding()
                } else if viewModel.favoriteRecipes.isEmpty {
                    Image("forkandKnife")
                    Text("You haven't favorited any recipe.\nFavorite something in the the Search or Recipe View!")
                        .font(.title)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                } else {
                    
                    LazyVGrid(columns: columns, spacing: 60) {
                        ForEach(viewModel.favoriteRecipes) { recipe in
                            Button {
                                self.selectedRecipe = recipe
                                self.showingSheet = true
                            } label: {
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
                                    Label("Remove Favorites", systemImage: "star.slash.fill")
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
            }
        }
        
        .scrollDisabled(viewModel.favoriteRecipes.isEmpty)
        .containerRelativeFrame([.horizontal, .vertical])
        //.padding(.top, 500)
        .background {
            BackgroundGeral()
        }
//        .sheet(isPresented: $showingSheet) {
//            if let id = selectedRecipeId {
//                RecipeQuickDetailView(recipeId: id, navigationPath: $navigationPath)
//            }
//        }
        .sheet(item: $selectedRecipe, content: { recipe in
            RecipeQuickDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
        })
    }
}

#Preview {
    FavoritesView(navigationPath: .constant(NavigationPath()))
}
