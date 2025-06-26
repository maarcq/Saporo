//
//  RecipeInstructionsViewModel.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 17/06/25.
//


import Foundation
import Combine

class RecipeInstructionsViewModel: ObservableObject {
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
}
