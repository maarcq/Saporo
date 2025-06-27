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
    
    var body: some View {
        
        VStack(alignment: .leading) {
            TabView {
                ForEach(HViewmodel.saoJoao.results, id: \.id) { recipe in
                    
                    NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, navigationPath: $navigationPath)) {
                        
                        BannerView(nameRecipe: recipe.title, imageRecipe: recipe.image!, preparationTime: recipe.readyInMinutes ?? 0, servings: recipe.servings ?? 0)
                    }
                }
            }
            .tabViewStyle(.page)
            .frame(height: 300)
        }
    }
}

//#Preview {
//    ListBanner(navigationPath: .constant(NavigationPath()), HViewmodel: <#HomeViewModel#>)
//}
