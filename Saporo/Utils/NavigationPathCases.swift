//
//  NavigationPathCases.swift
//  ipadOS
//
//  Created by Marcelle Ribeiro Queiroz on 25/06/25.
//

import Foundation


// MARK: NavigationPath
enum Destination: Hashable{
//    case preparoReceita
    case verMais(recipes: [Recipe], text: String)
    case recipeList(cuisine: String)
}
