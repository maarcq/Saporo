//
//  TabData.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import Foundation

enum Tabs: String, CaseIterable, Identifiable {
    case home, favorites, search, settings
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .home: return "Receitas"
        case .favorites: return "Favoritos"
        case .search: return "Pesquisar"
        case .settings: return "Configurações"
        }
    }
    
    var icon: String {
        switch self {
        case .home: return "receitasIcon"
        case .favorites: return "favoritosIcon"
        case .search: return "pesquisarIcon"
        case .settings: return "configIcon"
        }
    }
    
    var customizationID: String {
        "tab.\(rawValue)"
    }
}
