//
//  RecipeInstructionsView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 17/06/25.
//

import SwiftUI

struct RecipeInstructionsView: View {
    let misturar = "whisk"
    @StateObject private var viewModel: RecipeInstructionsViewModel
    @State private var scrolledID: Int? // Para controle de scroll
    
    init(analyzedInstructions: [RecipeInformation.AnalyzedInstruction]?) {
        _viewModel = StateObject(wrappedValue: RecipeInstructionsViewModel(analyzedInstructions: analyzedInstructions))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            if let errorMessage = viewModel.errorMessage {
                errorMessageView(message: errorMessage)
            } else if viewModel.allSteps.isEmpty {
                emptyInstructionsView()
            } else if viewModel.showCompletionMessage {
                completionMessageView()
            } else {
                mainContent
            }
        }
        .background {
            BackgroundGeral()
        }
        .navigationTitle("Preparo")
        .navigationBarTitleDisplayMode(.inline)
        .alert("Finalizar Receita", isPresented: $viewModel.showConfirmationAlert) {
            confirmationAlertButtons
        } message: {
            Text("Tem certeza que deseja finalizar a receita?")
        }
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        VStack {
            Spacer()
            HStack {
                stepCirclesView
                instructionsScrollView
            }
            Spacer()
            buttonsBar
        }
    }
    
    private var stepCirclesView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.allSteps.indices, id: \.self) { index in
                    stepCircle(index: index)
                        .padding(.vertical, 60)
                        .onTapGesture {
                            handleStepTap(index: index)
                        }
                }
                Spacer()
            }
            .onReceive(NotificationCenter.default.publisher(for: .NextStep)) { _ in
                viewModel.goToNextStep()
            }
            .padding()
            .frame(maxWidth: 100, maxHeight: .infinity)
        }
    }
    
    private func stepCircle(index: Int) -> some View {
        VStack {
            Text("\(index+1)")
                .scaleEffect(viewModel.currentStepIndex == index ? 1.4 : 1)
                .animation(.easeInOut, value: viewModel.currentStepIndex)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .background {
                    Circle()
                        .fill(Color("ColorCircleInstructions"))
                        .frame(width: 60, height: 60)
                        .scaleEffect(viewModel.currentStepIndex == index ? 1.3 : 1)
                        .animation(.easeInOut, value: viewModel.currentStepIndex)
                    
                    if index < viewModel.allSteps.count - 1 {
                        Rectangle()
                            .fill(Color("ColorCircleInstructions"))
                            .frame(width: 8, height: 100)
                            .offset(y: 80)
                            .zIndex(-1)
                    }
                }
        }
    }
    
    private var instructionsScrollView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.allSteps, id: \.id) { step in
                            instructionStepView(step: step)
                                .containerRelativeFrame(.vertical)
                                .id(step.id)
                                .scrollTransition(axis: .vertical) { content, phase in
                                    content
                                        .scaleEffect(x: phase.isIdentity ? 1.0 : 0.0,
                                                     y: phase.isIdentity ? 1.0 : 0.0)
                                }
                        }
                    }
                    .scrollTargetLayout()
                }
                .scrollPosition(id: $scrolledID)
                .scrollTargetBehavior(.paging)
                .onChange(of: scrolledID) { _, newValue in
                    if let id = newValue,
                       let index = viewModel.allSteps.firstIndex(where: { $0.id == id }) {
                        viewModel.currentStepIndex = index
                    }
                }
                .onChange(of: viewModel.currentStepIndex) { _, newIndex in
                    scrolledID = viewModel.allSteps[newIndex].id
                }
            }
        }
    }
    
    private func instructionStepView(step: RecipeInformation.InstructionStep) -> some View {
        VStack {
            Text(step.step)
                .font(.title2)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .cornerRadius(15)
                .padding(.top,100)
            if let image = viewModel.getImageName(for: step.step) {
                Image(image)
                    .resizable()
                    .scaledToFit()
            } else {
                EmptyView()
            }
        }
    }
    
    private var buttonsBar: some View {
        HStack(spacing: 20) {
            // Botões (mantive comentados como no original)
        }
        .padding(.bottom, 20)
    }
    
    private func errorMessageView(message: String) -> some View {
        Text(message)
            .foregroundColor(.red)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func emptyInstructionsView() -> some View {
        Text("Nenhum passo de instrução disponível para esta receita.")
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)
            .padding()
    }
    
    private func completionMessageView() -> some View {
        VStack {
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
        }
    }
    
    private var backgroundContent: some View {
        ZStack {
            Image("TextureHome")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            Color("Background")
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    private var confirmationAlertButtons: some View {
        Group {
            Button("Sim", role: .destructive) {
                viewModel.confirmFinishRecipe()
            }
            Button("Não", role: .cancel) {
                viewModel.cancelFinishRecipe()
            }
        }
    }
    
    // MARK: - Handlers
    private func handleStepTap(index: Int) {
        withAnimation(.easeInOut(duration: 0.7)) {
            viewModel.currentStepIndex = index
            scrolledID = viewModel.allSteps[index].id
        }
        viewModel.updateCurrentStepTextAndButtonState()
    }
}

#Preview {
    let sampleInstructions: [RecipeInformation.AnalyzedInstruction] = [
        RecipeInformation.AnalyzedInstruction(
            name: nil,
            steps: [
                RecipeInformation.InstructionStep(number: 1, step: "Cozinhe e whisk a massa conforme as instruções da embalagem até ficar al dente."),
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
