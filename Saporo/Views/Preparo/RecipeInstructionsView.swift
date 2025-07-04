//
//  RecipeInstructionsView.swift
//  ipadOS
//
//  Created by Bernardo Santos Maranhão Maia on 17/06/25.
//

import SwiftUI

struct RecipeInstructionsView: View {
    
    @StateObject private var viewModel: RecipeInstructionsViewModel
    @State private var scrolledID: Int?
    
    init(analyzedInstructions: [RecipeInformation.AnalyzedInstruction]?) {
        _viewModel = StateObject(wrappedValue: RecipeInstructionsViewModel(analyzedInstructions: analyzedInstructions))
    }
    
    var body: some View {
        VStack(spacing: 20) {
            mainContent
        }
        .background {
            BackgroundGeral()
        }
        .navigationTitle("Prepare")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Subviews
    private var mainContent: some View {
        HStack {
            //exibir e criar circulos baseado no numero de steps
            stepCirclesView
            //exibir e colocar a imagen de acordo com o passo
            instructionsScrollView
        }
    }
    
    private var stepCirclesView: some View {
        ScrollView {
            VStack {
                ForEach(viewModel.allSteps.indices, id: \.self) { index in
                    //criacao do circulo e da linha
                    stepCircle(index: index)
                        .padding(.vertical, 30)
                        .onTapGesture {
                            //logica para clica no circulo e mover para o passo
                            handleStepTap(index: index)
                        }
                }
                Spacer()
            }
            .onReceive(NotificationCenter.default.publisher(for: .PreviousStep)) { _ in
                viewModel.goToPreviousStep()
            }
            .onReceive(NotificationCenter.default.publisher(for: .NextStep)) { _ in
                //logica para falar com a siri para mover para o proximo passo
                viewModel.goToNextStep()
            }
            .padding()
            .frame(maxWidth: 100, maxHeight: .infinity)
            
        }
        .scrollIndicators(.hidden)
    }
    
    private func stepCircle(index: Int) -> some View {
        VStack {
            // numero do passo
            Text("\(index+1)")
                .scaleEffect(viewModel.currentStepIndex == index ? 1.4 : 1)
                .animation(.easeInOut, value: viewModel.currentStepIndex)
                .font(.title)
                .bold()
                .foregroundStyle(.white)
                .background {
                    //circulo vermelho
                    Circle()
                        .fill(Color("ColorCircleInstructions"))
                        .frame(width: 60, height: 60)
                        .scaleEffect(viewModel.currentStepIndex == index ? 1.3 : 1)
                        .animation(.easeInOut, value: viewModel.currentStepIndex)
                    
                    if index < viewModel.allSteps.count - 1 {
                        //linha entre os circulos
                        Rectangle()
                            .fill(Color("ColorCircleInstructions"))
                            .frame(width: 8, height: 50)
                            .offset(y: 50)
                            .zIndex(-1)
                    }
                }
        }
    }
    
    // MARK: - Handlers
    private func handleStepTap(index: Int) {
        withAnimation(.easeInOut(duration: 0.7)) {
            //usso scrolledID para guiar a scrollView pro passo clicado
            viewModel.currentStepIndex = index
            scrolledID = viewModel.allSteps[index].id
        }
        viewModel.updateCurrentStepTextAndButtonState()
    }
    
    private var instructionsScrollView: some View {
        VStack {
            ScrollViewReader { proxy in
                ScrollView(.vertical) {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.allSteps, id: \.id) { step in
                            // cria e exibi as imagens e o rexto do passo
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
                .ignoresSafeArea()
                .padding(.bottom,0.2)
                //logica q controla qual o passo atual
                .scrollPosition(id: $scrolledID)
                .scrollTargetBehavior(.paging)
                .onChange(of: scrolledID) { _, newValue in
                    //se o valor de scrollID mudar, a tela vai para o currentstepIndex daquele passo
                    if let id = newValue,
                       let index = viewModel.allSteps.firstIndex(where: { $0.id == id }) {
                        viewModel.currentStepIndex = index
                    }
                }
                .onChange(of: viewModel.currentStepIndex) { _, newIndex in
                    //se o valor de scrollID mudar, a tela vai para o ScroolID daquele passo
                    scrolledID = viewModel.allSteps[newIndex].id
                }
            }
        }
    }
    
    private func instructionStepView(step: RecipeInformation.InstructionStep) -> some View {
        VStack {
            //texto do passo a passo
            let formattedText = step.step.replacingOccurrences(of: "\\.(\\s|$)", with: ".\n", options: .regularExpression)
            
            Text(formattedText)
                .font(.poppinsRegular(size: 32))
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            //funcao para alinhas a imagem correta pro passo correto
            HStack(spacing: 30) {
                if let image = viewModel.getImageAction(for: step.step) {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200,height: 200)
                }
                if let image = viewModel.getImageInstruments(for: step.step) {
                    Image(image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 200,height: 200)
                }
                
            }
        }
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
