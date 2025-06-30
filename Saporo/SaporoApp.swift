//
//  SaporoApp.swift
//  Saporo
//
//  Created by Marcelle Ribeiro Queiroz on 26/06/25.
//

import SwiftUI

@main
struct SaporoApp: App {
    var body: some Scene {
        let sampleInstructions: [RecipeInformation.AnalyzedInstruction] = [
            RecipeInformation.AnalyzedInstruction(
                name: nil,
                steps: [
                    RecipeInformation.InstructionStep(number: 1, step: "Cozinhe whisk a massa conforme as instruções da embalagem até ficar al dente."),
                    RecipeInformation.InstructionStep(number: 2, step: "Enquanto a massa cozinha, aqueça o azeite em uma frigideira grande em fogo médio-alto."),
                    RecipeInformation.InstructionStep(number: 3, step: "Adicione o alho picado e cozinhe por 1 minuto até ficar perfumado, tomando cuidado para não queimar."),
                    RecipeInformation.InstructionStep(number: 4, step: "Escorra a massa e adicione-a à frigideira com o molho. Misture bem para cobrir a massa. Sirva imediatamente.")
                ]
            )
        ]
        WindowGroup {
            ContentView()
//            RecipeInstructionsView(analyzedInstructions: sampleInstructions)
        }
    }
}
