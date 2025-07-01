//
//  HomeItensView.swift
//  ipadOS
//
//  Created by Natanael nogueira on 17/06/25.
//

import Foundation
import SwiftUI

struct HomeItensView: View {
    
    let image: String
    let nameRecipe: String
    let maxReadyTime: Int?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            //            Image(image)
            //                .resizable()
            //                .scaledToFill()
            //                .frame(width: 200, height: 150)
            //                .cornerRadius(16)
            
            //            AsyncImage(url: URL(string: image)) { image in
            //                image.image?
            //                    .resizable()
            //                    .scaledToFill()
            //                    .frame(width: 200, height: 180)
            //                    .cornerRadius(16)
            //            }
            
            if let url = URL(string: image), image.contains("http") {
                // Imagem de URL (API)
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                            .frame(width: 200, height: 180)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 180)
                            .cornerRadius(16)
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .frame(width: 200, height: 180)
                            .cornerRadius(16)
                    @unknown default:
                        EmptyView()
                    }
                }
            } else {
                // Imagem local
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 180)
                    .cornerRadius(16)
                    .clipped()
            }
            
            VStack(alignment: .leading, spacing: 8) {
                Text(nameRecipe)
                    .font(.poppinsRegular(size: 18))
                    .foregroundStyle(.labels)
                    .lineLimit(1)
                    .frame(width: 200, alignment: .leading)
                
                if let time = maxReadyTime {
                    Text("\(time) min")
                        .font(.poppinsRegular(size: 18))
                        .foregroundStyle(.labels.opacity(0.8))
                }
            }
        }
    }
}

#Preview {
    HomeItensView(
        image: "ImageTest",
        nameRecipe: "Pé de Molequeasdasdd",
        maxReadyTime: 10
    )
}
