//
//  ColorExtension.swift
//  ipadOS
//
//  Created by Marcelle Ribeiro Queiroz on 25/06/25.
//

import Foundation
import SwiftUI

struct BackgroundGeral: View {
    var body: some View {
        
        ZStack {
            Color("Background")
                .edgesIgnoringSafeArea(.all)
            
            Image("TextureHome")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    BackgroundGeral()
}
