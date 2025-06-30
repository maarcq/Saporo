//
//  ListBanner.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

struct ListBanner: View {
    
    @Binding var navigationPath: NavigationPath
    var HViewmodel: HomeViewModel
    
    var body: some View {
        
        VStack(alignment: .leading) {
            BannerView(recipes: HViewmodel.sobremesas.results)
        }
    }
}

#Preview {
    ListBanner(navigationPath: .constant(NavigationPath()), HViewmodel: HomeViewModel())
}
