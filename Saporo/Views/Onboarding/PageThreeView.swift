//
//  PageThreeView.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 02/07/25.
//

import SwiftUI

struct PageThreeView: View {
    
    @AppStorage("isOnboardingComplete") private var isOnboardingComplete: Bool = false
    
    var body: some View {
        ZStack {
            Color.colorCircleInstructions
                .ignoresSafeArea(edges: .all)
            Image("TextureHome")
                .resizable()
                .scaledToFill()
            
            VStack(spacing: UIScreen.main.bounds.size.height/15) {
                
                Text("Affordable, practical and personalized for you!")
                    .font(.foodPacker(size: 60))
                    .foregroundStyle(Color(.background))
                
                VStack(alignment: .leading, spacing: 100) {
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Recipe navigation can be done using voice commands with Siri, without the need to touch the screen.")
                            .font(.poppinsRegular(size: 40))
                            .foregroundStyle(Color(.background))
                            .lineLimit(5)
                            .frame(maxWidth: 950, alignment: .leading)
                        
                        Image("onb3")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 60)
                    }
                    .padding(.leading, UIScreen.main.bounds.size.width/15)
                    .padding(.trailing, UIScreen.main.bounds.size.width/5)
                    
                    Button {
                        isOnboardingComplete = true
                    } label: {
                        Text("Start")
                            .font(.poppinsBold(size: 40))
                            .foregroundStyle(Color(.background))
                            .padding(.horizontal, 100)
                            .padding(.vertical, 8)
                            .background {
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(.greenLabel))
                            }
                    }
                    .padding(.leading, UIScreen.main.bounds.size.width/15)
                }
            }
            .padding(.top, UIScreen.main.bounds.size.height/15)
            .frame(width: UIScreen.main.bounds.size.width,
                   height: UIScreen.main.bounds.size.height,
                   alignment: .top)
            .overlay(alignment: .bottomTrailing) {
                Image("desenho3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 340)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    PageThreeView()
}
