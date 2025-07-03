//
//  ListSobremesas.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListCafeDaManha: View {
    
    @Binding var navigationPath: NavigationPath
    @State private var showingSheet: Bool = false
    @State private var selectedRecipe: Recipe?
    
    var HViewmodel: HomeViewModel
    let category: String = "Breakfast"

    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                navigationPath.append(Destination.verMais(recipes: HViewmodel.breadRecipes.results, text: category))
            } label: {
                HStack{
                    Text(category)
                        .font(.poppinsMedium(size: 24))
                        .foregroundStyle(Color("LabelsColor"))
                    Text(">")
                        .font(Font.poppinsBold(size: 30))
                        .padding(.horizontal, 8)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(HViewmodel.breadRecipes.results.prefix(10), id: \.id) { recipe in
                        Button {
                            self.selectedRecipe = recipe
                            self.showingSheet = true
                        } label: {
                            VStack {
                                HomeItensView(image: recipe.image!, nameRecipe: recipe.title, maxReadyTime: recipe.readyInMinutes!)
                            }
                        }
                    }
                }
                .padding(.trailing)
            }
        }
        .sheet(item: $selectedRecipe, content: { recipe in
            RecipeQuickDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
        })
    }
}

#Preview {
    ListCafeDaManha(navigationPath: .constant(NavigationPath()), HViewmodel: HomeViewModel())
}
