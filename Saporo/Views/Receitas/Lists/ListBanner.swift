//
//  ListBanner.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListBanner: View {
    
    @Binding var navigationPath: NavigationPath
    
    var HViewmodel: HomeViewModel
    
    @State private var showingSheet: Bool = false
    @State private var selectedRecipeId: Int?
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TabView {
                ForEach(HViewmodel.saoJoao.results, id: \.id) { recipe in
                    Button {
                        self.selectedRecipeId = recipe.id
                        self.showingSheet = true
                    } label: {
                        BannerView(nameRecipe: recipe.title, imageRecipe: recipe.image!, preparationTime: recipe.readyInMinutes ?? 0, servings: recipe.servings ?? 0)
                    }
                }
            }
            .tabViewStyle(.page)
            .frame(height: 300)
        }
        .sheet(isPresented: $showingSheet) {
            if let id = selectedRecipeId {
                RecipeQuickDetailView(recipeId: id, navigationPath: $navigationPath) // APRESENTA A NOVA SHEET
            }
        }
    }
}

//#Preview {
//    ListBanner(navigationPath: .constant(NavigationPath()), HViewmodel: <#HomeViewModel#>)
//}
