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
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(spacing: 24) {
                // MARK: BANNER COM 3 EXEMPLOS DE RECEITAS
                ListBanner(navigationPath: $navigationPath)
                
                // MARK: LISTA COM COMIDAS DE SÃO JOÃO
                ListSaoJoao(navigationPath: $navigationPath)
                    .padding(.leading)
                
                // MARK: LISTA COM COMIDAS SOBREMESAS
                ListSobremesas(navigationPath: $navigationPath)
                    .padding(.leading)
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
    
#Preview {
    HomeView(navigationPath: .constant(NavigationPath()))
}
