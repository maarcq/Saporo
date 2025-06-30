//
//  RecipeInstructionsViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 17/06/25.
//

import Foundation
import Combine

class RecipeInstructionsViewModel: ObservableObject {
    private let palavrasChaves: [String: String] = [
        "whisk": "Misturar", // Ex: whisk, mix, combine -> imagem "AcaoMisturar"
        "mix": "Misturar",
        "combine": "Misturar",
        "beat": "AcaoBater",      // Ex: beat -> imagem "AcaoBater"
        "cut": "Cortar",      // Ex: cut, chop, slice, dice -> imagem "AcaoCortar"
        "chop": "Cortar",
        "slice": "Cortar",
        "dice": "Cortar",
        "knead": "Amassar",   // Ex: knead -> imagem "AcaoAmassar"
        "bake": "Assar",      // Ex: bake, preheat -> imagem "AcaoAssar"
        "preheat": "Assar",
        "cook": "Cozinhar",   // Ex: cook, heat -> imagem "AcaoCozinhar"
        "heat": "Cozinhar"
    ]
    @Published var currentStepIndex: Int = 0
    @Published var currentStepText: String = ""
    @Published var errorMessage: String? = nil
    
    // MARK: Novos estados para o botão Concluir e mensagem de parabéns
    @Published var showFinishButton: Bool = false
    @Published var showConfirmationAlert: Bool = false
    @Published var showCompletionMessage: Bool = false
    
    let allSteps: [RecipeInformation.InstructionStep] // Todos os passos
    
    // Construtor que recebe as instruções analisadas da RecipeDetailView
    init(analyzedInstructions: [RecipeInformation.AnalyzedInstruction]?) {
        guard let instructions = analyzedInstructions,
              let firstInstructionSet = instructions.first,
              !firstInstructionSet.steps.isEmpty else {
            self.allSteps = []
            self.errorMessage = "Instruções passo a passo não disponíveis."
            return
        }
        
        self.allSteps = firstInstructionSet.steps
        updateCurrentStepTextAndButtonState() // Define o texto do primeiro passo e o estado do botão
    }
    
    // MARK: - Lógica de Navegação dos Passos
    var canGoToPreviousStep: Bool {
        currentStepIndex > 0
    }
    
    var canGoToNextStep: Bool {
        currentStepIndex < allSteps.count - 1
    }
    
    func goToNextStep() {
        if canGoToNextStep {
            currentStepIndex += 1
            updateCurrentStepTextAndButtonState()
        }
    }
    
    func goToPreviousStep() {
        if canGoToPreviousStep {
            currentStepIndex -= 1
            updateCurrentStepTextAndButtonState()
        }
    }
    
    func updateCurrentStepTextAndButtonState() {
        guard currentStepIndex >= 0 && currentStepIndex < allSteps.count else {
            currentStepText = "Fim das instruções."
            showFinishButton = true
            return
        }
        currentStepText = allSteps[currentStepIndex].step
        showFinishButton = (currentStepIndex == allSteps.count - 1)
    }
    
    func didTapFinishRecipe() {
        showConfirmationAlert = true
    }
    
    func confirmFinishRecipe() {
        showConfirmationAlert = false
        showCompletionMessage = true
    }
    
    func cancelFinishRecipe() {
        showConfirmationAlert = false
    }
    
    func getImageName(for stepText: String) -> String? {
        // Converte o texto do passo para minúsculas para a busca não diferenciar maiúsculas/minúsculas
        let lowercasedStep = stepText.lowercased()
        
        // Percorre o dicionário
        for (keyword, imageName) in palavrasChaves {
            if lowercasedStep.contains(keyword) {
                // Se encontrar uma palavra-chave, retorna o nome da imagem imediatamente
                return imageName
            }
        }
        
        // Se o loop terminar e não encontrar nenhuma palavra-chave, retorna nil
        return nil
    }
}

