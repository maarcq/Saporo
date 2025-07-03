//
//  AppIntents.swift
//  ipadOS
//
//  Created by Natanael nogueira on 11/06/25.
//

import AppIntents

extension Notification.Name {
    static let openHomeTab = Notification.Name("openHomeTab")
    static let openFavoritesTab = Notification.Name("openFavoritesTab")
    static let openSearchTab = Notification.Name("openSeachTab")
    static let NextStep = Notification.Name("NextStep")
    static let PreviousStep = Notification.Name("PreviousStep") // Notificação para voltar passo
    static let SearchByVoice = Notification.Name("SearchByVoice") // Notificação para pesquisa por voz
}

struct MyAppShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: OpenHomeView(),
            phrases: ["abrir \(.applicationName) em receitas"],
            shortTitle: "Página Inicial",
            systemImageName: "hand.tap"
        )
        AppShortcut(
            intent: OpenFavView(),
            phrases: ["Abrir \(.applicationName) em favoritos"],
            shortTitle: "Favoritos",
            systemImageName: "hand.tap"
        )
        AppShortcut(
            intent: OpenSearchView(),
            phrases: ["Abrir \(.applicationName) em buscar receitas"],
            shortTitle: "Buscar receitas",
            systemImageName: "hand.tap"
        )
        AppShortcut(
            intent: NextStep(),
            phrases: ["próximo passo \(.applicationName)", "next step \(.applicationName)"],
            shortTitle: "Próximo passo",
            systemImageName: "hand.tap"
        )
        AppShortcut( // Atalho para voltar um passo
            intent: PreviousStep(),
            phrases: ["voltar passo \(.applicationName)", "passo anterior \(.applicationName)", "previous step \(.applicationName)"],
            shortTitle: "Voltar passo",
            systemImageName: "arrow.uturn.backward"
        )
        AppShortcut( // Atalho para buscar por voz
            intent: SearchByVoice(),
            phrases: ["buscar por voz em \(.applicationName)", "pesquisar receita por voz em \(.applicationName)"],
            shortTitle: "Buscar por voz",
            systemImageName: "mic.fill"
        )
    }
}

struct OpenHomeView: AppIntent {
    static var title: LocalizedStringResource = "Abrir Página Inicial"
    static var description = IntentDescription("Abre a página inicial do aplicativo.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .openHomeTab, object: nil)
        }
        return .result()
    }
}

struct OpenFavView: AppIntent {
    static var title: LocalizedStringResource = "Abrir Favoritos"
    static var description = IntentDescription("Abre a página de favoritos do aplicativo.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .openFavoritesTab, object: nil)
        }
        return .result()
    }
}

struct OpenSearchView: AppIntent {
    static var title: LocalizedStringResource = "Abrir Buscar receitas"
    static var description = IntentDescription("Abre a página de buscar do aplicativo.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .openSearchTab, object: nil)
        }
        return .result()
    }
}

struct NextStep: AppIntent {
    static var title: LocalizedStringResource = "Próximo passo"
    static var description = IntentDescription("Próximo passo da receita atual.")

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .NextStep, object: nil)
        }
        return .result()
    }
}

struct PreviousStep: AppIntent {
    static var title: LocalizedStringResource = "Voltar passo"
    static var description = IntentDescription("Volta para o passo anterior da receita atual.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .PreviousStep, object: nil)
        }
        return .result()
    }
}

struct SearchByVoice: AppIntent {
    static var title: LocalizedStringResource = "Buscar por voz"
    static var description = IntentDescription("Abre a tela de busca e prepara para entrada por voz.")
    static let openAppWhenRun = true

    func perform() async throws -> some IntentResult {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: .SearchByVoice, object: nil)
        }
        return .result()
    }
}
