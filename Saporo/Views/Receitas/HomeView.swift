//
//  HomeView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 11/06/25.
//

import SwiftUI

struct HomeView: View {
    
    @Binding var navigationPath: NavigationPath
    @State var HViewmodel = HomeViewModel()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                VStack(spacing: 20) {
                    TabView {
                        ForEach(HViewmodel.appleRecipes.results, id: \.id) { recipe in
                            NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                BannerView(nameRecipe: recipe.title, imageRecipe: recipe.image!, preparationTime: recipe.readyInMinutes ?? 0, servings: recipe.servings ?? 0)
                            }
                        }
                    }
                    .tabViewStyle(.page)
                    .frame(height: 300)
                    Text("Comidas de São João")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color("LabelsColor"))
                        .padding(.horizontal)
                        .font(.title2)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach(HViewmodel.appleRecipes.results, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                    VStack {
                                        HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Sobremesas")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color("LabelsColor"))
                        .padding(.horizontal)
                        .font(.title2)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach(HViewmodel.eggWhitesRecipes.results, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                    VStack {
                                        HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    Text("Sobremesas")
                        .frame(maxWidth: .infinity,alignment: .leading)
                        .foregroundStyle(Color("LabelsColor"))
                        .padding(.horizontal)
                        .font(.title2)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        HStack {
                            ForEach(HViewmodel.breadRecipes.results, id: \.id) { recipe in
                                NavigationLink(destination: RecipeDetailView(recipeId: recipe.id)) {
                                    VStack {
                                        HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .task {
                await HViewmodel.fetchRecipesByIngredients()
            }
        }
        .background {
            BackgroundGeral()
        }
    }
}

//#Preview {
//    HomeView()
//}
