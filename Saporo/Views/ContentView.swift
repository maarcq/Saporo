//
//  ContentView.swift
//  ipadOS
//
//  Created by Raynara Coelho on 05/06/25.
//

import SwiftUI

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
        case .home: return "book"
        case .favorites: return "star"
        case .search: return "magnifyingglass"
        case .settings: return "gear"
        }
    }
    
    var customizationID: String {
        "tab.\(rawValue)"
    }
}

struct ContentView: View {
    
    @State private var selectedTab: Tabs = .home
    @State private var navigationPath = NavigationPath()
    
    @AppStorage("sidebarCustomizations") private var tabViewCustomization: TabViewCustomization = TabViewCustomization()
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            
            TabView(selection: $selectedTab) {
                // MARK: RECEITAS
                Tab(Tabs.home.title, systemImage: Tabs.home.icon, value: Tabs.home) {
                    HomeView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.home.customizationID)
                
                // MARK: FAVORITOS
                Tab(Tabs.favorites.title, systemImage: Tabs.favorites.icon, value: Tabs.favorites) {
                    FavoritesView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.favorites.customizationID)
                
                // MARK: PESQUISAR
                Tab(Tabs.search.title, systemImage: Tabs.search.icon, value: Tabs.search) {
                    RecipeSearchView(navigationPath: $navigationPath)
                }
                .customizationID(Tabs.search.customizationID)
                //.customizationBehavior(.disabled, for: .tabBar)
                
                // MARK: CONFIGURAÇÕES
                Tab(Tabs.settings.title, systemImage: Tabs.settings.icon, value: Tabs.settings) {
                    SettingsView()
                }
                .customizationID(Tabs.settings.customizationID)
                //.customizationBehavior(.disabled, for: .sidebar, .tabBar)
            }
            .tabViewStyle(.sidebarAdaptable)
            .tabViewCustomization($tabViewCustomization)
            .tint(Color.red.opacity(0.8))
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

//    init() {
//        let appearance = UITabBarAppearance()
//        appearance.configureWithOpaqueBackground()
//        appearance.backgroundColor = UIColor.red
//
//        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.red]
//        appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.red]
//        appearance.stackedLayoutAppearance.normal.iconColor = UIColor.red
//        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.red.withAlphaComponent(0.8)
//
//        UITabBar.appearance().standardAppearance = appearance
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }


//    var body: some View {
//        TabView(selection: $selectedTab) {
//            NavigationStack {
//                HomeView()
//            }
//            .tabItem {
//                Label(Tab.home.rawValue, systemImage: Tab.home.iconName)
//            }
//            .tag(Tab.home)
//
//            NavigationStack {
//                FavoritesView()
//            }
//            .tabItem {
//                Label(Tab.favorites.rawValue, systemImage: Tab.favorites.iconName)
//            }
//            .tag(Tab.favorites)
//
//            NavigationStack {
//                RecipeSearchView()
//            }
//            .tabItem {
//                Label(Tab.searchRecipes.rawValue, systemImage: Tab.searchRecipes.iconName)
//            }
//            .tag(Tab.searchRecipes)
//        }
//        .tabViewStyle(.sidebarAdaptable)
//        .tint(Color.red.opacity(0.8))
//        .onReceive(NotificationCenter.default.publisher(for: .openHomeTab)) { _ in
//            selectedTab = .home
//        }
//        .onReceive(NotificationCenter.default.publisher(for: .openFavoritesTab)) { _ in
//            selectedTab = .favorites
//        }
//        }


#Preview {
    ContentView()
}
