//
//  ListSobremesas.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListCafeDaManha: View {
    
    @Binding var navigationPath: NavigationPath
    var HViewmodel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                navigationPath.append(Destination.verMais(recipes: HViewmodel.breadRecipes.results))
            } label: {
                HStack{
                    Text("Café da Manhã")
                        .font(.poppinsMedium(size: 24))
                        .foregroundStyle(Color("LabelsColor"))
                    Text(">")
                        .font(Font.poppinsBold(size: 30))
                        .padding(.horizontal, 8)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(HViewmodel.breadRecipes.results.prefix(5), id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, navigationPath: $navigationPath)) {
                            VStack {
                                HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                            }
                        }
                    }
                }
                .padding(.trailing)
            }
        }
    }
}

#Preview {
    ListCafeDaManha(navigationPath: .constant(NavigationPath()), HViewmodel: HomeViewModel())
}

