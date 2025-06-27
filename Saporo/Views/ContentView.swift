//
//  ContentView.swift
//  ipadOS
//
//  Created by Raynara Coelho on 05/06/25.
//

import SwiftUI
import UIKit

struct ContentView: View {
    
    @State private var selectedTab: Tabs = .home
    
    @State private var navigationPath = NavigationPath()
    
    @AppStorage("sidebarCustomizations") private var tabViewCustomization: TabViewCustomization = TabViewCustomization()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            TabView(selection: $selectedTab) {
                // MARK: PESQUISAR
                Tab(Tabs.search.title, image: Tabs.search.icon, value: Tabs.search) {
                    RecipeSearchView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.search.customizationID)
                
                // MARK: RECEITAS
                Tab(Tabs.home.title, image: Tabs.home.icon, value: Tabs.home) {
                    HomeView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.home.customizationID)
                
                // MARK: FAVORITOS
                Tab(Tabs.favorites.title, image: Tabs.favorites.icon, value: Tabs.favorites) {
                    FavoritesView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.favorites.customizationID)
                
                // MARK: CONFIGURAÇÕES
                Tab(Tabs.settings.title, image: Tabs.settings.icon, value: Tabs.settings) {
                    SettingsView()
                }
                .customizationID(Tabs.settings.customizationID)
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($tabViewCustomization)
            .tint(Color.labels)
            .onReceive(NotificationCenter.default.publisher(for: .openHomeTab)) { _ in
                selectedTab = .home
            }
            .onReceive(NotificationCenter.default.publisher(for: .openFavoritesTab)) { _ in
                selectedTab = .favorites
            }
            .onReceive(NotificationCenter.default.publisher(for: .openSearchTab)) { _ in
                selectedTab = .search
            }
            .navigationDestination(for: Destination.self) { destination in
                switch destination {
                case .preparoReceita:
                    HomeView(navigationPath: $navigationPath)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
