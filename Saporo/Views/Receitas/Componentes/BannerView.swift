//
//  BannerView.swift
//  ipadOS
//
//  Created by Natanael nogueira on 17/06/25.
//

import Foundation
import SwiftUI

struct BannerView: View {
    
    @Binding var navigationPath: NavigationPath
    
    @State private var showingSheet: Bool = false
    @State private var selectedRecipeId: Int?
    @State private var currentIndex: Int = 0
    
    let recipes: [Recipe]
    
    private var recipeinfo: Recipe? {
        guard recipes.indices.contains(currentIndex) else { return nil }
        return recipes[currentIndex]
    }
    
    var body: some View {
        Button {
            if let recipeinfo {
                self.selectedRecipeId = recipeinfo.id
                self.showingSheet = true
            }
        } label: {
            HStack(spacing: 16) {
                TabView (selection: $currentIndex) {
                    ForEach(Array(recipes.enumerated().prefix(5)), id: \.1.id) { index, recipe in
                        if let imageName = recipe.image {
                            AsyncImage(url: URL(string: imageName)) { image in
                                image.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 235)
                                    .cornerRadius(16)
                                    .padding(.leading)
                            }
                            .tag(index)
                        }
                    }
                }
                .tabViewStyle(.page)
                .frame(height: 250)
                
                if recipes.indices.contains(currentIndex) {
                    let recipe = recipes[currentIndex]
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text(recipe.title)
                            .font(.poppinsBold(size: 32))
                            .lineLimit(2)
                            .padding(.trailing)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Image(systemName: "clock")
                                Text("\(recipe.readyInMinutes ?? 0) min")
                            }
                            
                            HStack {
                                Image(systemName: "fork.knife")
                                Text("\(recipe.servings ?? 0) servings")
                            }
                        }
                        .font(.poppinsBold(size: 20))
                        .opacity(0.8)
                    }
                    .padding(24)
                    .frame(minWidth: 300, maxWidth: 400, maxHeight: 235, alignment: .topLeading)
                    .foregroundStyle(Color.background)
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("ColorCircleInstructions"))
                    )
                    .overlay(alignment: .bottomTrailing) {
                        Text(">")
                            .font(.poppinsBold(size: 40))
                            .foregroundStyle(.colorCircleInstructions)
                            .padding(8)
                            .background {
                                Circle().fill(Color("Background"))
                            }
                            .padding(.trailing, 16)
                            .padding(.bottom, 2)
                    }
                    .padding(.trailing)
                }
            }
        }
        .sheet(isPresented: $showingSheet) {
            if let id = selectedRecipeId {
                RecipeQuickDetailView(recipeId: id, navigationPath: $navigationPath)
            }
        }
    }
}

#Preview {
    BannerView(navigationPath:.constant(NavigationPath()) , recipes: [
        Recipe(
            id: 1,
            title: "Lasanha Bolonhesa",
            image: "ImageTest",
            imageType: "jpg",
            readyInMinutes: 45,
            servings: 4,
            cuisine: ""
        ),
        Recipe(
            id: 2,
            title: "Salada Caesar",
            image: "ImageTest",
            imageType: "jpg",
            readyInMinutes: 15,
            servings: 2,
            cuisine: ""
        )
    ])
}

