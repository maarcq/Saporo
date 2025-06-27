//
//  ListSaoJoao.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListSaoJoao: View {
    
    @Binding var navigationPath: NavigationPath
    @State var HViewmodel = HomeViewModel()
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Comidas de São João")
                .font(.poppinsMedium(size: 24))
                .foregroundStyle(Color("LabelsColor"))
            
            ScrollView(.horizontal,showsIndicators: false) {
                HStack {
                    ForEach(HViewmodel.appleRecipes.results, id: \.id) { recipe in
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
    ListSaoJoao(navigationPath: .constant(NavigationPath()))
}
