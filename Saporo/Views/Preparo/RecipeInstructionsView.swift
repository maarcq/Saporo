//
//  RecipeInstructionsView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 17/06/25.
//

import SwiftUI

struct RecipeInstructionsView: View {
    
    @StateObject private var viewModel: RecipeInstructionsViewModel
    
    init(analyzedInstructions: [RecipeInformation.AnalyzedInstruction]?) {
        _viewModel = StateObject(wrappedValue: RecipeInstructionsViewModel(analyzedInstructions: analyzedInstructions))
    }
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            if let errorMessage = viewModel.errorMessage {
                
                Text(errorMessage)
                    .foregroundColor(.red)
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else if viewModel.allSteps.isEmpty {
                
                Text("Nenhum passo de instrução disponível para esta receita.")
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                
            } else if viewModel.showCompletionMessage {
                
                Spacer()
                
                Image(systemName: "hand.thumbsup.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
                
                Text("Parabéns!\nReceita Finalizada!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                
            } else {
                
                Spacer()
                
                HStack {
                    VStack {
                        ForEach(viewModel.allSteps.indices, id: \.self) { index in
                            
                            VStack {
                                
                                Text("\(index + 1)")
                                    .scaleEffect(viewModel.currentStepIndex+1 == index+1 ? 1.4 : 1).animation(.easeInOut)
                                    .font(.title)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .background {
                                        Circle()
                                            .fill(Color("ColorCircleInstructions"))
                                            .frame(width: 60, height: 60)
                                            .scaleEffect(viewModel.currentStepIndex+1 == index+1 ? 1.3 : 1).animation(.easeInOut)
                                        if index < viewModel.allSteps.count - 1 {
                                            Rectangle()
                                                .fill(Color("ColorCircleInstructions"))
                                                .frame(width: 8, height: 100)
                                                .offset(y: 80)
                                                .zIndex(-1)
                                        }
                                    }
                            }
                            .padding(.vertical,60)
                            .onTapGesture {
                                do {
                                    viewModel.currentStepIndex = index
                                    print(viewModel.currentStepIndex)
                                    viewModel.updateCurrentStepTextAndButtonState()
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    .onReceive(NotificationCenter.default.publisher(for: .NextStep)) { _ in
                        viewModel.goToNextStep()
                    }
                    .padding()
                    .frame(maxWidth: 100, maxHeight: .infinity)
                    
                    VStack {
                        Text("Passo \(viewModel.currentStepIndex + 1) de \(viewModel.allSteps.count)")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(viewModel.currentStepText)
                            .font(.title2)
                            .fontWeight(.medium)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(.systemGray6))
                            .cornerRadius(15)
                            .padding(.horizontal)
                    }
                }
                
                Spacer()
                
                HStack(spacing: 20) {
                    //                    Button(action: viewModel.goToPreviousStep) {
                    //                        Label("Anterior", systemImage: "arrow.left.circle.fill")
                    //                            .font(.title2)
                    //                            .padding(.vertical, 10)
                    //                            .padding(.horizontal, 20)
                    //                            .background(viewModel.canGoToPreviousStep ? Color.accentColor : Color.gray)
                    //                            .foregroundColor(.white)
                    //                            .cornerRadius(10)
                    //                    }
                    //                    .disabled(!viewModel.canGoToPreviousStep)
                    //
                    
                    if viewModel.showFinishButton {
                        //                        Button(action: viewModel.didTapFinishRecipe) {
                        //                            Label("Concluir", systemImage: "checkmark.circle.fill")
                        //                                .font(.title2)
                        //                                .padding(.vertical, 10)
                        //                                .padding(.horizontal, 20)
                        //                                .background(Color.green)
                        //                                .foregroundColor(.white)
                        //                                .cornerRadius(10)
                        //                        }
                    } else {
                        //                        Button(action: viewModel.goToNextStep) {
                        //                            Label("Próximo", systemImage: "arrow.right.circle.fill")
                        //                                .font(.title2)
                        //                                .padding(.vertical, 10)
                        //                                .padding(.horizontal, 20)
                        //                                .background(viewModel.canGoToNextStep ? Color.accentColor : Color.gray)
                        //                                .foregroundColor(.white)
                        //                                .cornerRadius(10)
                        //                        }
                        //                        .disabled(!viewModel.canGoToNextStep)
                        
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .background {
            BackgroundGeral()
        }
        .navigationTitle("Instruções")
        .navigationBarTitleDisplayMode(.inline)
        // MARK: Alerta de Confirmação
        .alert("Finalizar Receita", isPresented: $viewModel.showConfirmationAlert) {
            Button("Sim", role: .destructive) {
                viewModel.confirmFinishRecipe()
            }
            Button("Não", role: .cancel) {
                viewModel.cancelFinishRecipe()
            }
        } message: {
            Text("Tem certeza que deseja finalizar a receita?")
        }
    }
}

#Preview {
    let sampleInstructions: [RecipeInformation.AnalyzedInstruction] = [
        RecipeInformation.AnalyzedInstruction(
            name: nil,
            steps: [
                RecipeInformation.InstructionStep(number: 1, step: "Cozinhe a massa conforme as instruções da embalagem até ficar al dente."),
                RecipeInformation.InstructionStep(number: 2, step: "Enquanto a massa cozinha, aqueça o azeite em uma frigideira grande em fogo médio-alto."),
                RecipeInformation.InstructionStep(number: 3, step: "Adicione o alho picado e cozinhe por 1 minuto até ficar perfumado, tomando cuidado para não queimar."),
                RecipeInformation.InstructionStep(number: 4, step: "Escorra a massa e adicione-a à frigideira com o molho. Misture bem para cobrir a massa. Sirva imediatamente.")
            ]
        )
    ]
    
    NavigationView {
        RecipeInstructionsView(analyzedInstructions: sampleInstructions)
    }
}
