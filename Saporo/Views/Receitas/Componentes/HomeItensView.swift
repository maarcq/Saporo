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
    let maxReadyTime: Int
    
    var body: some View {
        VStack {
//            Image(image)
//                .resizable()
//                .scaledToFill()
//                .frame(width: 200, height: 150)
//                .cornerRadius(16)
            
            AsyncImage(url: URL(string: image)) { image in
                image.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 180)
                    .cornerRadius(16)
            }
            
            VStack(alignment: .leading) {
                Text(nameRecipe)
                    .padding(.top,4)
                    .foregroundStyle(.black)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                    .frame(width: 200,alignment: .leading)
                
                Text("\(maxReadyTime) min")
                    .foregroundStyle(.gray)
            }
            .frame(width: 200,alignment: .leading)
        }
    }
}

struct BottomRoundedRectangle: Shape {
    var radius: CGFloat = 15

    func path(in rect: CGRect) -> Path {
        var path = Path()

        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - radius))
        path.addArc(
            center: CGPoint(x: rect.maxX - radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .zero,
            endAngle: .degrees(90),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX + radius, y: rect.maxY))
        path.addArc(
            center: CGPoint(x: rect.minX + radius, y: rect.maxY - radius),
            radius: radius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))

        return path
    }
}

#Preview {
    HomeItensView(
        image: "ImageTest",
        nameRecipe: "Panqueca de Banana",
        maxReadyTime: 10
    )
}
