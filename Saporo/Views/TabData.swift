//
//  TabData.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import Foundation
import SwiftUICore

enum Tabs: String, CaseIterable, Identifiable {
    case home, favorites, search, settings
    
    var id: String { rawValue }
    
    var title: LocalizedStringKey {
        switch self {
        case .home: return "Recipes"
        case .favorites: return "Favorites"
        case .search: return "Search"
        case .settings: return "Settings"
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
