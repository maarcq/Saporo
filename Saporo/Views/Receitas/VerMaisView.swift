//
//  VerMaisView.swift
//  Saporo
//
//  Created by Natanael nogueira on 27/06/25.
//

import SwiftUI

struct VerMaisView: View {
    @State private var showingSheet: Bool = false
    @State private var selectedRecipe: Recipe?
    @Binding var navigationPath: NavigationPath
    
    var text: String
    var receitas: [Recipe]
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(receitas) { receita in
                    VStack {
                        Button{
                            self.selectedRecipe = receita
                            self.showingSheet = true
                        } label: {
                            HomeItensView(image: receita.image ?? "", nameRecipe: receita.title, maxReadyTime: receita.readyInMinutes ?? 0)
                                .scaleEffect(0.9)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle(text)
        .background(
            BackgroundGeral()
        )
        .sheet(item: $selectedRecipe, content: { recipe in
            RecipeQuickDetailView(recipeId: recipe.id, navigationPath: $navigationPath)
        })
    }
}

#Preview {
    VerMaisView(navigationPath: .constant(NavigationPath()), text: "", receitas: [
        Recipe(id: 1, title: "Bolo de Cenoura", image: "ImageTest", imageType: nil, readyInMinutes: 45, servings: 8, cuisine: "italian"),
        Recipe(id: 2, title: "Pizza Margherita", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2, cuisine: "italian"),
        Recipe(id: 23, title: "Pizza Margherita1", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2, cuisine: "italian"),
        Recipe(id: 24, title: "Pizza Margherita2", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2, cuisine: "italian"),
        Recipe(id: 25, title: "Pizza Margherita3", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2, cuisine: "italian"),
        Recipe(id: 26, title: "Pizza Margherita4", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2, cuisine: "italian")
    ])
}
