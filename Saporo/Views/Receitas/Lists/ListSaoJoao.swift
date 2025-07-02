//
//  ListSaoJoao.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListSaoJoao: View {
    
    @Binding var navigationPath: NavigationPath
    @State private var showingSheet: Bool = false
    @State private var selectedRecipe: Recipe?
    
    var HViewmodel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Button {
                navigationPath.append(Destination.verMais(recipes: HViewmodel.saoJoao.results))
            } label: {
                HStack{
                    Text("Comidas de São João")
                        .font(.poppinsMedium(size: 24))
                        .foregroundStyle(Color("LabelsColor"))
                    Text(">")
                        .font(Font.poppinsBold(size: 30))
                        .padding(.horizontal, 8)
                }
            }
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(HViewmodel.saoJoao.results.prefix(5), id: \.id) { recipe in
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
            }
        }
        .sheet(isPresented: $showingSheet) {
            if let selectedRecipe = selectedRecipe {
                RecipeQuickDetailView(recipeId: selectedRecipe.id, navigationPath: $navigationPath) // MODIFICADO AQUI
            }
        }
    }
}

#Preview {
    ListSaoJoao(navigationPath: .constant(NavigationPath()), HViewmodel: HomeViewModel())
}
