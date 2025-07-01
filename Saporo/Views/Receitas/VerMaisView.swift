//
//  VerMaisView.swift
//  Saporo
//
//  Created by Natanael nogueira on 27/06/25.
//

import SwiftUI

struct VerMaisView: View {
    var receitas: [Recipe]
    let columns = Array(repeating: GridItem(.flexible()), count: 4)
    var text: String
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 0) {
                ForEach(receitas) { receita in
                    VStack {
                        Button{
                            print("clicou no card id:\(receita.id)")
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
    }
}
    
//#Preview {
//    VerMaisView(receitas: [
//        Recipe(id: 1, title: "Bolo de Cenoura", image: "ImageTest", imageType: nil, readyInMinutes: 45, servings: 8),
//        Recipe(id: 2, title: "Pizza Margherita", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2),
//        Recipe(id: 23, title: "Pizza Margherita1", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2),
//        Recipe(id: 24, title: "Pizza Margherita2", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2),
//        Recipe(id: 25, title: "Pizza Margherita3", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2),
//        Recipe(id: 26, title: "Pizza Margherita4", image: "ImageTest", imageType: nil, readyInMinutes: 20, servings: 2)
//    ], text: "")
//}
