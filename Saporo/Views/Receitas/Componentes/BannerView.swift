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
        HStack {
            AsyncImage(url: URL(string: imageRecipe)) { image in
                image.image?
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 500, height: 300)
                    .cornerRadius(16)
            }
//            
//            Image(imageRecipe)
//                .resizable()
//                .aspectRatio(contentMode: .fill)
//                .frame(width: 600, height: 300)
//                .cornerRadius(16)
            
            VStack(alignment: .leading) {
                
                VStack(alignment: .leading, spacing: 20) {
                    Text(nameRecipe)
                        .font(.poppinsBold(size: 32))
                        .lineLimit(2)
                    
                    HStack {
                        Image(systemName: "clock")
                        Text("\(preparationTime) min")
                    }
                    .font(.poppinsBold(size: 20))
                    .foregroundStyle(.white)
                    .opacity(0.7)
                    
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("\(servings) porções")
                    }
                    .font(.poppinsBold(size: 20))
                    .foregroundStyle(.white)
                    .opacity(0.7)
                }
                
                Spacer()
                
                HStack {
                    Spacer()
                    
                    Image(systemName: "arrow.forward.circle")
                        .font(.largeTitle)
                }
            }
            .padding()
            .frame(width: 300, height: 300)
            .bold()
            .foregroundStyle(Color.white)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color("ColorCircleInstructions"))
            )
        }
    }
}

#Preview {
    BannerView(nameRecipe: "Lasanha de Frango", imageRecipe: "ImageTest",preparationTime: 30,servings: 0)
}
