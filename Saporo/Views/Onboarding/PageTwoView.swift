//
//  PageTwoView.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 02/07/25.
//

import SwiftUI

struct PageTwoView: View {
    
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool = false
    
    var body: some View {
        ZStack {
            Color.colorCircleInstructions
                .ignoresSafeArea(edges: .all)
            Image("TextureHome")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: UIScreen.main.bounds.size.height/15) {
                
                Text("Simplify the act of cooking!")
                    .font(.foodPacker(size: 64))
                    .foregroundStyle(Color(.background))
                
                VStack(alignment: .leading, spacing: 16) {
                    
                    Text("Easy to understand step-by-step recipe making preparation easier.")
                        .font(.poppinsRegular(size: 40))
                        .foregroundStyle(Color(.background))
                        .lineLimit(3)
                        .frame(maxWidth: 950, alignment: .leading)
                    
                    Image("onb2")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 450)
                }
                .padding(.leading, UIScreen.main.bounds.size.width/15)
                .padding(.trailing, UIScreen.main.bounds.size.width/5)
            }
            .padding(.top, UIScreen.main.bounds.size.height/15)
            .frame(width: UIScreen.main.bounds.size.width,
                   height: UIScreen.main.bounds.size.height,
                   alignment: .top)
            .overlay(alignment: .bottomTrailing) {
                Image("desenho2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 340)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PageTwoView()
}
