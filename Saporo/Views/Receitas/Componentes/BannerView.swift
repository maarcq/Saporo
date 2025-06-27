//
//  BannerView.swift
//  ipadOS
//
//  Created by Natanael nogueira on 17/06/25.
//

import Foundation
import SwiftUI

struct BannerView: View {
    
    let nameRecipe: String
    let imageRecipe: String
    let preparationTime: Int
    let servings: Int
    
    var body: some View {
        HStack(spacing: 16) {
            AsyncImage(url: URL(string: imageRecipe)) { image in
                image.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 235)
                    .cornerRadius(16)
            }
            
            Image(imageRecipe)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(height: 235)
                .cornerRadius(16)
                        
            VStack(alignment: .leading, spacing: 24) {
                Text(nameRecipe)
                    .font(.poppinsBold(size: 32))
                    .lineLimit(2)
                    .padding(.trailing)
                
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "clock")
                        Text("\(preparationTime) min")
                    }
                    
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("\(servings) porções")
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
                Button {
                    // COLOCAR A AÇÃO DE ABRIR A SHEET
                } label: {
                    Text(">")
                        .font(.poppinsBold(size: 40))
                        .foregroundStyle(.colorCircleInstructions)
                        .padding(8)
                        .background {
                            Circle().fill(Color("Background"))
                        }
                }
                .padding(.trailing, 16)
                .padding(.bottom, 2)
            }
        }
        .padding(.horizontal)
    }
}

#Preview {
    BannerView(nameRecipe: "Lasanha de Frango com queijo e espinafre", imageRecipe: "ImageTest",preparationTime: 30,servings: 12)
}
