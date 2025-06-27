//
//  ListSobremesas.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListSobremesas: View {
    
    @Binding var navigationPath: NavigationPath
    
    var HViewmodel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                navigationPath.append(Destination.verMais(recipes: HViewmodel.sobremesas.results))
            } label: {
                HStack{
                    Text("Sobremesas")
                        .font(.poppinsMedium(size: 24))
                        .foregroundStyle(Color("LabelsColor"))
                    Text(">")
                        .font(Font.poppinsBold(size: 30))
                        .padding(.horizontal, 8)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(HViewmodel.sobremesas.results.prefix(5), id: \.id) { recipe in
                        NavigationLink(destination: RecipeDetailView(recipeId: recipe.id, navigationPath: $navigationPath)) {
                            VStack {
                                HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                            }
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ListSobremesas(navigationPath: .constant(NavigationPath()), HViewmodel: HomeViewModel())
}

